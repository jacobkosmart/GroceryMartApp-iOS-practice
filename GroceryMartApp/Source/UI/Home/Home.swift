//
//  Home.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2021/12/31.
//

import SwiftUI

struct Home: View {
	// store 프로퍼티 추가
	let store: Store
	
	var body: some View {
		NavigationView {
			List(store.products) { product in
				// ProductDetailView 에 
				NavigationLink(destination: ProductDetailView(product: product)) {
					ProductRow(product: product)
				}
				
				// navigationTitle 은 네비게이션 뷰의 범위 바깥이 아닌 안쪽에 추가해야 함
					.navigationTitle("Fruit Mart")
			}
			.listStyle(GroupedListStyle())
		}
	}
}

struct Home_Previews: PreviewProvider {
	static var previews: some View {
		Home(store: Store())
	}
}


