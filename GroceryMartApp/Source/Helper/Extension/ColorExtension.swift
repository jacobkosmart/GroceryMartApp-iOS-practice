//
//  ColorExtension.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2021/12/31.
//

import SwiftUI

extension Color {
	static let peach = Color("peach") // 앱에서 사용할 메인색
	static let primaryShadow = Color.primary.opacity(0.2) // 그림자에 사용할 색
	static let secondaryText = Color(hex: "#6e6e6e") // Color.seconday 를 대신해 사용할 조금 더 진한 회색
	static let background = Color(uiColor: .systemGray6)
}

// Color HEX 코드 변환 logic
extension Color {
	init(hex: String) {
		let scanner = Scanner(string: hex) // 문자열 파서 역활을 하는 클래스
		_ = scanner.scanString("#") // scanString은 iOS 13부터 지원. "#" 문자 제거
		
		var rgb: UInt64 = 0
		// 문자열을 Int64 타입으로 변환해 rbg 변수에 저장. 변환할 수 없다면 0 반환
		scanner.scanHexInt64(&rgb)
		
		let r = Double((rgb >> 16) & 0xFF) / 255.0 // 좌측 문자열 2개 추출
		let g = Double((rgb >>  8) & 0xFF) / 255.0 // 중간 문자열 2개 추출
		let b = Double((rgb >>  0) & 0xFF) / 255.0 // 우측 문자열 2개 추출
		self.init(red: r, green: g, blue: b)
	}
}
