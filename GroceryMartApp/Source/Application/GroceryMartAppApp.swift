//
//  GroceryMartAppApp.swift
//  GroceryMartApp
//
//  Created by Jacob Ko on 2021/12/31.
//

import SwiftUI

@main
struct GroceryMartAppApp: App {
	var body: some Scene {
		WindowGroup {
			Home(store: Store())
		}
	}
}
