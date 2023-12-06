//
//  CloudKitExampleApp.swift
//  CloudKitExample
//
//  Created by Maria Kotyak on 06/12/2023.
//

import SwiftUI

@main
struct CloudKitExampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
