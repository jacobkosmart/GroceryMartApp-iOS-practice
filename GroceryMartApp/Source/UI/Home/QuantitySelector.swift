//
//  QuantitySelector.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2022/01/07.
//

import SwiftUI

struct QuantitySelector: View {
	// @Binding 을 사용한 이유는 QuantitySelector 는 상위 뷰가 전달해 준 숫자를 표기하고 변경한 값을
	// 다시 원청 자료와 동기화 할 뿐, 이 값을 직접 소유할 필요가 없기 때문에 State 대신 Binding 을 사용
	@Binding var quantity: Int
	// range: 수량 선택 가능 범위
	var range: ClosedRange<Int> = 1...20
	
	// 햅틱 변수 생성(UIKit)
	private let softFeedback = UIImpactFeedbackGenerator(style: .soft) // 부드러운 진동
	private let rigidFeedback = UIImpactFeedbackGenerator(style: .rigid) // 딱딱한 진동
	
	var body: some View {
		HStack {
			// 수량 감소 버튼
			Button(action: { self.changeQuantity(-1) }) {
				Image(systemName: "minus.circle.fill")
					.imageScale(.large)
					.padding()
			}
			.foregroundColor(Color.gray.opacity(0.5))
			
			// 현재 수량을 나타내는 텍스트
			Text("\(quantity)")
				.bold()
			// 기본 폰트를 그대로 사용하면 0 ~9 까지의 숫자마다 각각 그 너비가 조금씩 달라서 숫자가 바뀔때마다
			// 불안정하게 흔들리는 모습니 보입니다. ,monospaced 폰트 디자인을 적용하면 숫자가 변하더라도
			// 일관성 있게 유지 합니다
				.font(Font.system(.title, design: .monospaced))
				.frame(minWidth: 40, maxWidth: 60)
			
			// 수량 증가 버튼
			Button(action: { self.changeQuantity(1)}) {
				Image(systemName: "plus.circle.fill")
					.imageScale(.large)
					.padding()
			}
			.foregroundColor(Color.gray.opacity(0.5))
		}
	}
	
	// MARK: Action
	private func changeQuantity(_ num: Int) {
		// ~= 연산자는 우측의 값이 좌측 값에 포함되었는지 판단합니다.
		// 따라서 지정된 범위 (기본값 1 ~ 20) 내에 변경되는 경우에만 실제로 값이 반영됩니다
		if range ~= quantity + num {
			quantity += num
			softFeedback.prepare() // 진동 지연 시간을 줄일 수 있도록 미리 준비시키는 method
			// 수량을 변경했을 때 지정한 범위 내의 값이면 softFeedback 으로 부드러운 진동을 울리도록 함
			// impactOccurred 메서드에서 진동의 세기를 0 ~ 1 사이로 진동의 세기를 조절 할 수 있음
			softFeedback.impactOccurred(intensity: 0.8)
		} else {
			rigidFeedback.prepare()
			// 변경된 수량이 지정한 범위를 벗어날 때, 즉 1 에서 - 누르거나 20에서 + 를 눌렀을 경우 더 강한 진동인 rigidFeedback 을 발생 시킵니다
			rigidFeedback.impactOccurred()
		}
	}
}

struct QuantitySelector_Previews: PreviewProvider {
	
	// 프리뷰에서 Binding 타입에 값을 전잘 할때는 constant 을 이용해서 값을 전달해 줍니다
	static var previews: some View {
		Group {
			QuantitySelector(quantity: .constant(1))
			QuantitySelector(quantity: .constant(10))
			QuantitySelector(quantity: .constant(20))
		}
		.padding()
		.previewLayout(.sizeThatFits)
	}
}
