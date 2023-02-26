//
//  bsideApp.swift
//  bside
//
//  Created by Justin Hunter on 2/21/23.
//

import SwiftUI

@main
struct bsideApp: App {
    @StateObject var audioManager = AudioManager()
    let persistenceController = PersistenceController.shared
    var network = NetworkRequests()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(network)
                .environmentObject(audioManager)
        }
    }
}
