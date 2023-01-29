//
//  NotesApp.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

@main
struct NotesApp: App {
    @StateObject var сoreDataController = CoreDataController()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, сoreDataController.container.viewContext)
        }
    }
}
