//
//  ContentView.swift
//  test-music
//
//  Created by Justin Hunter on 2/14/23.
//

import SwiftUI
import CoreData
import FlowSDK
import SafariServices

struct ContentView: View {
    @EnvironmentObject var network: NetworkRequests
    @ObservedObject var viewModel = FCLViewModel()
    var body: some View {
        AuthView(network: network)
            .onAppear {
                network.getCatalog()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(NetworkRequests())
    }
}
