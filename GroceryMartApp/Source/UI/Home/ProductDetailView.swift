//
//  ProductDetailView.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2022/01/05.
//

import SwiftUI

struct ProductDetailView: View {
	
	// Store instance 생성
	@EnvironmentObject private var store: Store
	let product: Product // 상품 정보를 전달 받기 위한 프로퍼티 선언
	
	@State private var quantity: Int = 1
	@State private var showingAlert: Bool = false
	
	var body: some View {
		VStack(spacing: 0) {
			productImage // 상품 이미지
			orderView // 상품 정보를 출력하고 그 상품을 주문하기 위한 뷰
		}
		// Edge.Set 타입을 전달하여 기본적으로 뷰의 안전 영역(Safe Area) 를 무시하고 설정한 위치에 View 를 구성할 수 있음
		.edgesIgnoringSafeArea(.top)
		// alert 수식어 추가
		.alert("주문확인",
					 isPresented: $showingAlert,
					 actions: { confirmAlert },
					 message: { alertMessage }
		)
	}
}

private extension ProductDetailView {
	// MARK: View
	// 상품 이미지르 표현 하는 뷰
	var productImage: some View {
		// 상품의 이미지를 최상단 뷰가 지오메트리 리더가 되고, 고정된 높이 값으로 나타냄
		GeometryReader { _ in
			Image(self.product.imageName)
				.resizable()
				.scaledToFill()
		}
	}
	
	// 상품 설명과 주문하기 버튼 등을 모두 포함하는 컨테이너
	var orderView: some View {
		GeometryReader {
			VStack (alignment: .leading) {
				self.productDescription
				Spacer()
				self.priceInfo
				self.placeOrderButton
			}
			// 지오메트리 리더가 차지하는 뷰의 높이보다 Vstack 의 높이가 10 크도록 지정
			.frame(height: $0.size.height + 10)
			.padding(32)
			.background(Color.white) // 다크모드에서도 흰색 배경을 위해 white 지정
			.cornerRadius(20)
			.shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
		}
	}
	
	// 상품명과 즐겨찾기 버튼, 상품 설명을 표시하는 뷰
	var productDescription: some View {
		VStack (alignment: .leading, spacing: 16) {
			HStack {
				Text(product.name) // 상품명
					.font(.largeTitle).fontWeight(.medium)
					.foregroundColor(.black)
				
				Spacer()
				
				// 즐겨찾기 버튼 - 하트아이콘 : FavoriteButton 적용
				FavoriteButton(product: product)
			}
			
			Text(splitText(product.description)) // 상품설명
				.foregroundColor(.secondaryText)
				.fixedSize() // 뷰가 작아져도 텍스트가 생략되지 않고 온전히 표현되도록 하기
		}
	}
	
	// 상품 가격을 표시하는 뷰
	var priceInfo: some View {
		let price = quantity * product.price // 수량 * 상품 가격
		
		return HStack {
			(Text("₩") // 통화 기호는 작게 나타내고 가격만 더 크게 표시
			 + Text("\(price)").font(.title).font(.title)
			).fontWeight(.medium)
			
			Spacer()
			// QuantitySelector 추가
			QuantitySelector(quantity: $quantity)
		}
		// 배경을 다크 모드에서도 항상 흰색이 되게 지정해 텍스트도 항상 검은색이 되게 지정
		.foregroundColor(.black)
	}
	
	// 주문하기 버튼
	var placeOrderButton: some View {
		Button(action: {
			self.showingAlert = true // 주문하기 버튼을 눌렀을때 알림장 출력
		}) {
			Capsule()
				.fill(Color.peach)
			// 너비는 주어진 공간을 최대로 사용하고, 높이는 최소, 최대치 지정함
				.frame(maxWidth: .infinity, minHeight: 30, maxHeight: 55)
				.overlay(Text("주문하기").font(.system(size: 20)).fontWeight(.medium).foregroundColor(Color.white))
				.padding(.vertical, 30)
		}
	}
	
	// Alert Actions
	var confirmAlert: some View {
		HStack {
			Button("취소", role: .cancel){}
			Button("확인") {
				// 확인 버튼 눌렀을때 동작하도록 구현
				self.placeOrder()
			}
		}
	}
	// Alert message
	var alertMessage: some View {
		Text(splitText("\(product.name) 을(를) \(quantity) 개 구매하시겠습니까?"))
	}
	
	// MARK: Computed Values
	// fuc splitText: 한문장으로 길게 구성된 상품 설면 문장을, 화면에 좀더 적절하게 나타내기 위해 두줄로 나누는 method
	func splitText(_ text: String) -> String {
		guard !text.isEmpty else { return text }
		let centerIdx = text.index(text.startIndex, offsetBy: text.count / 2)
		let centerSpaceIdx = text[..<centerIdx].lastIndex(of: " ")
		?? text[centerIdx...].firstIndex(of: " ")
		?? text.index(before: text.endIndex)
		let afterSpaceIdx = text.index(after: centerSpaceIdx)
		let lhsString = text[..<afterSpaceIdx].trimmingCharacters(in: .whitespaces)
		let rhsString = text[afterSpaceIdx...].trimmingCharacters(in: .whitespaces)
		return String(lhsString + "\n" + rhsString)
	}
	
	// MARK: Action
	// 상품과 수량 정보를 placeOrder 메서드에 인수로 전달
	func placeOrder() {
		store.placeOrder(product: product, quantity: quantity)
	}
	
}

struct ProductDetailView_Previews: PreviewProvider {
	static var previews: some View {
		ProductDetailView(product: productSamples[0])
	}
}
