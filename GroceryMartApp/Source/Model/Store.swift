//
//  Store.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2022/01/04.
//

import Foundation

final class Store {
	var products: [Product]
	
	// Store 인스턴스가 생성될때 파일 이름을 다른 것으로 지정하지 않는다면, Bundle Extension 파일에서 작성한 기능을 이용해서
	// ProductData.json 파일에 있는 데이터를 복호화하여 products 프로퍼티에 저장할 합니다
	init(filename: String = "ProductData.json") {
		self.products = Bundle.main.decode(filename: filename, as: [Product].self)
	}
}
