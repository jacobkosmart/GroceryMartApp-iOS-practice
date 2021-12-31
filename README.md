# 💊 drugAlert-iOS-practice

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
// in Alert.swift

import Foundation

struct Alert: Codable {
	var id: String = UUID().uuidString
	let date: Date
	var isOn: Bool

	// 시간을 형변환
	var time: String {
		let timeFormatter = DateFormatter()
		timeFormatter.dateFormat = "hh:mm"
		return timeFormatter.string(from: date)
	}

	// 날짜 값을 받아서 한국의 시간이 오전, 오후 인지 값을 받을 수 있음
	var meridiem: String {
		let meridiemFormatter = DateFormatter()
		meridiemFormatter.dateFormat = "a"
		meridiemFormatter.locale = Locale(identifier: "ko")
		return meridiemFormatter.string(from: date)
	}
}
```

### 🔷 Content 설정

#### NotificationCenter 추가, 설정

- Notification 을 관리하는 NotificationCenter 를 `AppDelegate.swift` 경로에 설정합니다

```swift
//  AppDelegate.swift

import NotificationCenter

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// UserNotificationCenter delegate 생성
		UNUserNotificationCenter.current().delegate = self
		return true
	}
	....
}

// MARK: extension UserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {

	// notificationCenter handling
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.banner, .list, .badge, .sound])
	}
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		completionHandler()
	}
}
```

#### User 에게 Notification 의 사용을 허가 여부를 묻기

- 만약에 alert 의 대한 notification 을 허용하지 않으면, 권한이 없기 때문에 설정한 Notification 이 표시 되지 않기 때문에, 앱 실행 하고, Notification 을 사용할 수 있게 유저에게 권한을 허가 받는 코드를 넣어 줘야 함

```swift
//  AppDelegate.swift

// UserNotification 권한을 묻기
		let authorizationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
		userNotificationCenter?.requestAuthorization(options: authorizationOptions) { _, error in
			if let error = error {
				print("ERROR: notification authrization request \(error.localizedDescription)")
			}
		}
```

#### local Notification 생성

- `AlertListViewController` 에서 알람 생성이 되고, alertList 에서 switch 가 켜질때 추가가 되야됨

```swift
//  UNNotificationCenter.swift

import Foundation
import UserNotifications

extension UNUserNotificationCenter {

	// alert 객체를 받아서 request 를 만들고, 최종적으로 notificationCenter 에 추가하는 method
	func addNotificationRequest(by alert: Alert) {
		let content = UNMutableNotificationContent()
		content.title = "약 먹을 시간 이에요 💊"
		content.body = "대한의사협회에서 권장되는 약 복용 시간은 식후 30분 후 입니다"
		content.sound = .default
		content.badge = 1 // 자동적으로 badge 가 사라지지는 않음
	}
}
```

#### 생성된 badge 삭제

- 위에서 badge 가 1로 생성되고 나서 사용자가 app 에 접속하면 자동으로 사라지는 것이 아니라, 수동으로 없애 줘야 합니다

```swift
//  SceneDelegate.swift

func sceneDidBecomeActive(_ scene: UIScene) {
	// 사용자가 app 을 열었는때 전송된 badge 를 0으로 설정해서 없애주기
	UIApplication.shared.applicationIconBadgeNumber = 0
}
```

### 🔷 Trigger 설정

- local Notification 을 활성화 시키는, 즉 alert 을 발생시키는 조건인 Trigger 를 작성해 주어야 합니다

```swift

//  UNNotificationCenter.swift

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
	.....
		// trigger 에 사용되는 DateComponents 생성
		let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)

		// trigger 생성: UNCalendarNotificationTrigger ( 어떠한 date조건에 할것인지와 반복을 설정해 줍니다 - 스위치가 켜져 있는 동안만 계속 반복해서 사용함)
		let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
	}
}
```

### 🔷 Request 설정

- contents 와 trigger 에서 만들어놓은 구성요소들을 NotificationCenter 에 추가 해줍니다

```swift
import UserNotifications

extension UNUserNotificationCenter {

	.....
		// request 생성
		let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
		// UNUserNotificationCenter 에 추가 시키기
		self.add(request, withCompletionHandler: nil)
	}
}
```

- 생성된 `addNotificationRequest` method 를 alert 이 발생하는 2곳에 추가 시킵니다

👉 첫번째 : timePicker 로 새로운 알람이 생성 될때 경우

```swift
//  AlertListViewController.swift

@IBAction func tapAddAlertBtn(_ sender: UIBarButtonItem) {
.....
// notification 추가 하기
self.userNotificationCenter.addNotificationRequest(by: newAlert)

......
}
```

👉 두번째 : isOn 스위치가 true 일 경우

```swift
//  AlertListCell.swift

	@IBAction func tabAlertSwitch(_ sender: UISwitch) {

.......
		// 처음에는 on상태이고, alertListViewController 에서 껏다가 다시 켠 경우에 추가 해줘야함
		if sender.isOn {
			userNotificationCenter.addNotificationRequest(by: alerts[sender.tag])
		}
	}

```

- NotificationCenter 에서 request 된거 삭제하기 (2군데)

👉 첫번째 : alertListView 에서 스와이프 해서 삭제 하는 경우

```swift
	// cell 이 edit 할때의 logic 추가 : .delete 삭제 일 경우에만
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .delete:
		.....
			// 삭제 될때도 notificationCenter 에서 삭제 해줌: center 가 가지고 있는 request 중에서 남아있는 notification 요청 중(pending 상태) id에 해당되는 것만 삭제 한다는 것!
			userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[indexPath.row].id])
			// tableView reload
			self.tableView.reloadData()
			return
		default:
			break
		}
	}
}

```

👉 두번째 : cell 의 switch 가 false 인 경우

```swift
//  AlertListCell.swift
	// MARK: Actions
	@IBAction func tabAlertSwitch(_ sender: UISwitch) {
		guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
					var alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return }

		alerts[sender.tag].isOn = sender.isOn
		UserDefaults.standard.set(try? PropertyListEncoder().encode(alerts), forKey: "alerts")

		// 처음에는 on상태이고, alertListViewController 에서 껏다가 다시 켠 경우에 추가 해줘야함
		if sender.isOn {
			userNotificationCenter.addNotificationRequest(by: alerts[sender.tag])
		} else { // sender.isOn 이 false 일때는 NotificationCenter 애서 request 삭제 해줘야함
			userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[sender.tag].id])
		}
	}
```

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

fastcampus - [https://fastcampus.co.kr/dev_online_iosappfinal](https://fastcampus.co.kr/dev_online_iosappfinal)
