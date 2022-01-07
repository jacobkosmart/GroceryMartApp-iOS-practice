//
//  FavoriteButton.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2022/01/07.
//

import SwiftUI

struct FavoriteButton: View {
	@EnvironmentObject private var store: Store
	let product: Product
	
	private var imageName: String {
		// 즐겨 찾기 여부에 따라 심벌 변경
		product.isFavorite ? "heart.fill" : "heart"
	}
	
	var body: some View {
		Image(systemName: imageName)
			.imageScale(.large)
			.foregroundColor(.peach)
			.frame(width: 32, height: 32)
		// 홈화면에서 누를때 내비게이션 링크가 먼저 반응해서 상세 화면으로 이동해 버림
		// onTapGesture 를 사용해 네비게이션 링크나 버튼 같은 컨트롤보다 터치 이벤트에 우선순위가 있어 사용됨
			.onTapGesture {
				self.store.toggleFavorite(of: self.product)
			}
	}
}

struct FavoriteButton_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			FavoriteButton(product: productSamples[0]) // isFavorite false 일 때
			FavoriteButton(product: productSamples[2]) // isFavorite true 일 때
		}
		.padding()
		.previewLayout(.sizeThatFits)
	}
}
