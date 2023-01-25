//
//  TabBarView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 16/01/2023.
//

import SwiftUI

enum Tab {
    case duke
    case bluetooth
}

struct TabBarView: View {
    @State private var tabSelection: Tab = .duke

    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView {
                DukeControlView(viewModel: DukeControlViewModel(), tabSelection: $tabSelection)
            }
            .tabItem {
                Label("Duke", systemImage: "headphones")
            }
            .tag(Tab.duke)
            NavigationView {
                BleScannerView(viewModel: BleScannerViewModel())
            }
            .tabItem {
                Label("Bluetooth", systemImage: "antenna.radiowaves.left.and.right")
            }
            .tag(Tab.bluetooth)
        }
        .accentColor(.brown)
    }
}
