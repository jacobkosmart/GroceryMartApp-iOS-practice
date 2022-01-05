# 🥬 GroceryMartApp-iOS-practice

<!-- ! gif 스크린샷 -->

## 📌 기능 상세

- 미리 설정된 약 먹을 시간이 되면 Local Notification 을 통해서 알람이 울리고, home 화면에 뱃지가 표시 되게 합니다

<!-- ## 👉 Pod library -->

<!-- ### 🔷  -->

<!-- >  -->

<!-- #### 설치

`pod init`

```ruby

```

`pod install`
 -->

## 🔑 Check Point !

### 🔷 UI Structure

<!-- ! 스토리보드, 앱 구조 ppt 스샷 -->

### 🔷 Model

```swift

```

### 🔷 ProductRow Cell

- 상품의 image, title, description, price, fav btn 등 재사용 가능한 cell 을 만들어서 json 에서 해당 데이터를 받아와서 UI 에 표시 해 줍니다

```swift
struct ProductRow: View {
	let product: Product

	var body: some View {
		HStack {
			productImage
			productDescription
		}
		.frame(height: 150)
		// cell 아래 테투리 그림자 처리:
		// 1.뷰의 배경색을 불투명 색처리 - .background...
		// 2.테두리 둥들게 처리
		// 3. 해당 뷰에 shadow 처리
		.background(Color.primary.colorInvert())
		.cornerRadius(10)
		.shadow(color: Color.primaryShadow, radius: 1, x: 2, y: 2)
		.padding(8)
	}
}

private extension ProductRow {

	// 상품 이미지
	var productImage: some View {
		Image(product.imageName)
			.resizable()
			.scaledToFill()
			.frame(width: 140)
			.clipped()
	}

	var productDescription: some View {
		VStack(alignment: .leading) { // 정렬 기준 변경
			// 상품명 부분에 작성
			Text(product.name)
				.font(.headline)
				.fontWeight(.medium)
				.padding(.bottom, 6)

			// 상품 설명 부분에 작성
			Text(product.description)
				.font(.footnote)
				.foregroundColor(Color.secondaryText)

			Spacer()

			priceFavBtn

		}
		.padding([.leading, .bottom], 12)
		.padding([.top, .trailing])
	}

	var priceFavBtn: some View {
		HStack (spacing: 0){ // HStack 이 가진 자식 뷰 사이의 간격을 0을 지정
			// 가격 정보
			Text("W").font(.footnote)
			+ Text("\(product.price)").font(.headline)

			Spacer()

			// 하트아이콘 : asset 에 미리 포함한 peach 색 사용
			Image(systemName: "heart")
				.imageScale(.large)
				.foregroundColor(Color("peach"))
				.frame(width: 32, height: 32)

			// 카트아이콘
			Image(systemName: "cart")
				.imageScale(.large)
				.foregroundColor(Color.peach)
				.frame(width: 32, height: 32)
		}
	}
}

struct ProductRow_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			ProductRow(product: productSamples[0])
			ProductRow(product: productSamples[1])
			ProductRow(product: productSamples[2])
		}
	}
}
```

<img width="350" alt="스크린샷 2021-12-31 오후 7 17 00" src="https://user-images.githubusercontent.com/28912774/147817725-2f019547-f5be-4ddf-b45d-7dfbf430062b.png">

### 🔷 리스트를 이용한 상품 목록 표시하기

#### 👉 데이터 변화 하기

```swift
// in BundleExtension.swift

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
```

#### 👉 Store 모델 생성

```swift
// in Store.swift

final class Store {
	var products: [Product]

	// Store 인스턴스가 생성될때 파일 이름을 다른 것으로 지정하지 않는다면, Bundle Extension 파일에서 작성한 기능을 이용해서
	// ProductData.json 파일에 있는 데이터를 복호화하여 products 프로퍼티에 저장할 합니다
	init(filename: String = "ProductData.json") {
		self.products = Bundle.main.decode(filename: filename, as: [Product].self)
	}
}
```

#### 👉 상품 목록 표시하기

- `Home.swift` 에서 store 프로퍼티를 추가하고 리스트를 이용해 각 상품들을 나열해 줍니다

```swift
// in Home.swift

struct Home: View {
	// store 프로퍼티 추가
	let store: Store

	var body: some View {
		// List 의 ID 설정은 Product.swift 에서 id: UUID = UUID() identifiable 프로토콜 준수르르 위한 id 프로퍼티 추가
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
```

### 🔷 네비게이션 링크를 통한 화면 전환하기

- 네비게이션 바 타이틀 및 네비게이션 링크를 통한 화면전환을 설정해 줍니다

```swift
// in Home.swift

import SwiftUI

struct Home: View {
	// store 프로퍼티 추가
	let store: Store

	var body: some View {
		NavigationView {
			List(store.products) { product in
				NavigationLink(destination: Text("상세 정보")) {
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
```

<img width="300" alt="스크린샷 2022-01-04 오전 6 51 16" src="https://user-images.githubusercontent.com/28912774/148141880-b87e76b1-94e5-4740-b36c-b7b949fb6b32.gif">

### 🔷 상품 상세 화면 구현하기

- 네비게이션 링크에 연결된 실제 상세 화면을 구현합니다

```swift
// in ProductDetailView.swift

import SwiftUI

struct ProductDetailView: View {

	let product: Product // 상품 정보를 전달 받기 위한 프로퍼티 선언

	var body: some View {
		VStack(spacing: 0) {
			productImage // 상품 이미지
			orderView // 상품 정보를 출력하고 그 상품을 주문하기 위한 뷰
		}
		// Edge.Set 타입을 전달하여 기본적으로 뷰의 안전 영역(Safe Area) 를 무시하고 설정한 위치에 View 를 구성할 수 있음
		.edgesIgnoringSafeArea(.top)
	}
}

private extension ProductDetailView {
	// MARK: View
	// 상품 이미지르 표현 하는 뷰
	var productImage: some View {
		// 상품의 이미지를 최상단 뷰가 지오메트리 리더가 되고, 고정된 높이 값으로 나타냄
		GeometryReader { _ in
			Image(self.product.imageName)
				.resizable()
				.scaledToFill()
		}
	}

	// 상품 설명과 주문하기 버튼 등을 모두 포함하는 컨테이너
	var orderView: some View {
		GeometryReader {
			VStack (alignment: .leading) {
				self.productDescription
				Spacer()
				self.priceInfo
				self.placeOrderButton
			}
			// 지오메트리 리더가 차지하는 뷰의 높이보다 Vstack 의 높이가 10 크도록 지정
			.frame(height: $0.size.height + 10)
			.padding(32)
			.background(Color.white) // 다크모드에서도 흰색 배경을 위해 white 지정
			.cornerRadius(20)
			.shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
		}
	}

	// 상품명과 즐겨찾기 버튼, 상품 설명을 표시하는 뷰
	var productDescription: some View {
		VStack (alignment: .leading, spacing: 16) {
			HStack {
				Text(product.name) // 상품명
					.font(.largeTitle).fontWeight(.medium)
					.foregroundColor(.black)

				Spacer()

				Image(systemName: "heart") // 즐겨찾기 버튼
					.imageScale(.large)
					.foregroundColor(Color.peach)
					.frame(width: 32, height: 32)
			}

			Text(splitText(product.description)) // 상품설명
				.foregroundColor(.secondaryText)
				.fixedSize() // 뷰가 작아져도 텍스트가 생략되지 않고 온전히 표현되도록 하기
		}
	}

	// 상품 가격을 표시하는 뷰
	var priceInfo: some View {
		HStack {
			(Text("₩") // 통화 기호는 작게 나타내고 가격만 더 크게 표시
			 + Text("\(product.price)").font(.title).font(.title)
			).fontWeight(.medium)

			Spacer()
			// 수량 선택 버튼이 들어갈 위치
		}
		// 배경을 다크 모드에서도 항상 흰색이 되게 지정해 텍스트도 항상 검은색이 되게 지정
		.foregroundColor(.black)
	}

	// 주문하기 버튼
	var placeOrderButton: some View {
		Button(action: {}) {
			Capsule()
				.fill(Color.peach)
			// 너비는 주어진 공간을 최대로 사용하고, 높이는 최소, 최대치 지정함
				.frame(maxWidth: .infinity, minHeight: 30, maxHeight: 55)
				.overlay(Text("주문하기").font(.system(size: 20)).fontWeight(.medium).foregroundColor(Color.white))
				.padding(.vertical, 30)
		}
	}

	// MARK: Computed Values
	// fuc splitText: 한문장으로 길게 구성된 상품 설면 문장을, 화면에 좀더 적절하게 나타내기 위해 두줄로 나누는 method
	func splitText(_ text: String) -> String {
		guard !text.isEmpty else { return text }
		let centerIdx = text.index(text.startIndex, offsetBy: text.count / 2)
		let centerSpaceIdx = text[..<centerIdx].lastIndex(of: " ")
		?? text[centerIdx...].firstIndex(of: " ")
		?? text.index(before: text.endIndex)
		let afterSpaceIdx = text.index(after: centerSpaceIdx)
		let lhsString = text[..<afterSpaceIdx].trimmingCharacters(in: .whitespaces)
		let rhsString = text[afterSpaceIdx...].trimmingCharacters(in: .whitespaces)
		return String(lhsString + "\n" + rhsString)
	}
}

struct ProductDetailView_Previews: PreviewProvider {
	static var previews: some View {
		ProductDetailView(product: productSamples[0])
	}
}
```

<img width="300" alt="스크린샷 2022-01-05 오전 11 31 04" src="https://user-images.githubusercontent.com/28912774/148151468-83f3c0a8-6868-4a5e-8a13-818be1435660.png">

---

> Describing check point in details in Jacob's DevLog - https://jacobko.info/firebaseios/ios-firebase-03/

<!-- ## ❌ Error Check Point

### 🔶 -->

<!-- xcode Mark template -->

<!--
// MARK: IBOutlet
// MARK: LifeCycle
// MARK: Actions
// MARK: Methods
// MARK: Extensions
-->

<!-- <img width="300" alt="스크린샷" src=""> -->

---

🔶 🔷 📌 🔑 👉

## 🗃 Reference

Jacob's DevLog - []()
