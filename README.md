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
