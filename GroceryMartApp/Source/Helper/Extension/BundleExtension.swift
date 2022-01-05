//
//  BundleExtension.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2022/01/04.
//

import Foundation

// 파일명을 전달받으면 번들에 있는 파일로 접근해 JSON 구조의 데이터를 Foundation 프레임워크에서 사용할 수 있는 타입으로 변환하는 기능을 합니다
extension Bundle {
	func decode<T: Decodable>(filename: String, as type: T.Type) -> T {
		guard let url = self.url(forResource: filename, withExtension: nil) else {
			fatalError("번들에 \(filename)이 없습니다.")
		}
		guard let data = try? Data(contentsOf: url) else {
			fatalError("\(url)로부터 데이터를 불러올 수 없습니다.")
		}
		guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
			fatalError("데이터 복호화에 실패했습니다")
		}
		return decodedData
	}
}
