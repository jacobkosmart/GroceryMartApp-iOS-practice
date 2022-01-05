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
		List(store.products) { product in
			ProductRow(product: product)
		}
	}
}

struct Home_Previews: PreviewProvider {
	static var previews: some View {
		Home(store: Store())
	}
}


