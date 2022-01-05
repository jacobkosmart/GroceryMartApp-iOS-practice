//
//  ProductDetailView.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2022/01/05.
//

import SwiftUI

struct ProductDetailView: View {
	
	let product: Product // 상품 정보를 전달 받기 위한 프로퍼티 선언
	
	var body: some View {
		VStack(spacing: 0) {
			productImage // 상품 이미지
			orderView // 상품 정보를 출력하고 그 상품을 주문하기 위한 뷰
		}
		// Edge.Set 타입을 전달하여 기본적으로 뷰의 안전 영역(Safe Area) 를 무시하고 설정한 위치에 View 를 구성할 수 있음
		.edgesIgnoringSafeArea(.top)
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
				
				Image(systemName: "heart") // 즐겨찾기 버튼
					.imageScale(.large)
					.foregroundColor(Color.peach)
					.frame(width: 32, height: 32)
			}
			
			Text(splitText(product.description)) // 상품설명
				.foregroundColor(.secondaryText)
				.fixedSize() // 뷰가 작아져도 텍스트가 생략되지 않고 온전히 표현되도록 하기
		}
	}
	
	// 상품 가격을 표시하는 뷰
	var priceInfo: some View {
		HStack {
			(Text("₩") // 통화 기호는 작게 나타내고 가격만 더 크게 표시
			 + Text("\(product.price)").font(.title).font(.title)
			).fontWeight(.medium)
			
			Spacer()
			// 수량 선택 버튼이 들어갈 위치
		}
		// 배경을 다크 모드에서도 항상 흰색이 되게 지정해 텍스트도 항상 검은색이 되게 지정
		.foregroundColor(.black)
	}
	
	// 주문하기 버튼
	var placeOrderButton: some View {
		Button(action: {}) {
			Capsule()
				.fill(Color.peach)
			// 너비는 주어진 공간을 최대로 사용하고, 높이는 최소, 최대치 지정함
				.frame(maxWidth: .infinity, minHeight: 30, maxHeight: 55)
				.overlay(Text("주문하기").font(.system(size: 20)).fontWeight(.medium).foregroundColor(Color.white))
				.padding(.vertical, 30)
		}
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
	
}

struct ProductDetailView_Previews: PreviewProvider {
	static var previews: some View {
		ProductDetailView(product: productSamples[0])
	}
}
