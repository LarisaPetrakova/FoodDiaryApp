//
//  Food_diaryApp.swift
//  Food diary
//
//  Created by Larisa Petrakova on 28/06/2024.
//

import SwiftUI

@main
struct Food_diaryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
