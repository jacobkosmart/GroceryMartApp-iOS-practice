//
//  ProductRow.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2021/12/31.
//

import SwiftUI

struct ProductRow: View {
	let product: Product
	
	var body: some View {
		HStack {
			productImage
			productDescription
		}
		.frame(height: 150)
		// cell 아래 테투리 그림자 처리:
		// 1.뷰의 배경색을 불투명 색처리 - .background...
		// 2.테두리 둥들게 처리
		// 3. 해당 뷰에 shadow 처리
		.background(Color.primary.colorInvert())
		.cornerRadius(10)
		.shadow(color: Color.primaryShadow, radius: 1, x: 2, y: 2)
		.padding(8)
	}
}

private extension ProductRow {
	
	// 상품 이미지
	var productImage: some View {
		Image(product.imageName)
			.resizable()
			.scaledToFill()
			.frame(width: 140)
			.clipped()
	}
	
	var productDescription: some View {
		VStack(alignment: .leading) { // 정렬 기준 변경
			// 상품명 부분에 작성
			Text(product.name)
				.font(.headline)
				.fontWeight(.medium)
				.padding(.bottom, 6)
			
			// 상품 설명 부분에 작성
			Text(product.description)
				.font(.footnote)
				.foregroundColor(Color.secondaryText)
			
			Spacer()
			
			priceFavBtn

		}
		.padding([.leading, .bottom], 12)
		.padding([.top, .trailing])
	}
	
	var priceFavBtn: some View {
		HStack (spacing: 0){ // HStack 이 가진 자식 뷰 사이의 간격을 0을 지정
			// 가격 정보
			Text("W").font(.footnote)
			+ Text("\(product.price)").font(.headline)
			
			Spacer()
			
			// 하트아이콘 : FavoriteButton 적용
			FavoriteButton(product: product)
		
			
			// 카트아이콘
			Image(systemName: "cart")
				.imageScale(.large)
				.foregroundColor(Color.peach)
				.frame(width: 32, height: 32)
		}
	}
}


struct ProductRow_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			ProductRow(product: productSamples[0])
			ProductRow(product: productSamples[1])
			ProductRow(product: productSamples[2])
		}
	}
}
