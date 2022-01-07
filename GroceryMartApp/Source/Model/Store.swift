//
//  Store.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2022/01/04.
//

import Foundation

// environment 로 전역에서 store 의 모델의 데이터에 접근해서 가져오기 까문에 Store 의 type 을 ObserbableObject 로 해야 함
final class Store: ObservableObject {
	// @Published: products 프로퍼티에 특정 상품의 데이터가 변경되면 그 사실을 뷰들이 알아 채고 화면을 갱신하기 위해
	@Published var products: [Product]
	
	// 전체 주문 목록
	@Published var orders: [Order] = []
	
	// MARK: Initialization
	// Store 인스턴스가 생성될때 파일 이름을 다른 것으로 지정하지 않는다면, Bundle Extension 파일에서 작성한 기능을 이용해서
	// ProductData.json 파일에 있는 데이터를 복호화하여 products 프로퍼티에 저장할 합니다
	init(filename: String = "ProductData.json") {
		self.products = Bundle.main.decode(filename: filename, as: [Product].self)
	}
}

// MARK: Action
// 즐겨 찾기 정보를 변경하는 method
extension Store {
	func toggleFavorite(of product: Product) {
		guard let index = products.firstIndex(of: product) else { return }
		products[index].isFavorite.toggle()
	}
	
	// 주문할때 마다 orders 에 append 되게 하는 method
	func placeOrder(product: Product, quantity: Int) {
		let nextID = Order.orderSequence.next()!
		let order = Order(id: nextID, product: product, quantity: quantity)
		orders.append(order)
		print(orders) // append 되는거 정보 확인
	}
}
