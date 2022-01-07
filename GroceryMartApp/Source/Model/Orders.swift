//
//  Orders.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2022/01/07.
//

import Foundation

// 식별을 위한 Identifiable 프로토콜 채택
struct Order: Identifiable {
	
	static var orderSequence = sequence(first: 1) { $0 + 1}
	let id: Int
	let product: Product
	let quantity: Int
	
	var price: Int {
		product.price * quantity
	}
}
