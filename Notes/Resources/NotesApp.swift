//
//  NotesApp.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI
import Firebase

@main
struct NotesApp: App {

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
