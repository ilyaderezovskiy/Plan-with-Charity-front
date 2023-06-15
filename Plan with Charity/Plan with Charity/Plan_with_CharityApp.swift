//
//  Plan_with_CharityApp.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI

@main
struct Plan_with_CharityApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
