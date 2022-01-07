//
//  Home.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2021/12/31.
//

import SwiftUI

struct Home: View {
	// environment 객체 생성
	@EnvironmentObject private var store: Store
	
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
		// preview 는 Home 의 자식뷰에 속하지 않으므로 별개로 인스턴스를 만들어 줘야 함(Store 가 사용된 뷰는 instance 생성 해줘야 preview 가 작동함)
		Home()
			.environmentObject(Store())
	}
}


