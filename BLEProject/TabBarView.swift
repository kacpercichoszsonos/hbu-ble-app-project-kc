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
    case settings
    case passportSettings
}

struct TabBarView: View {
    @State private var tabSelection: Tab = .passportSettings

    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView {
                PlayerView(viewModel: PlayerViewModel(), tabSelection: $tabSelection)
            }
            .tabItem {
                Label("Player", systemImage: "music.note")
            }
            .tag(Tab.duke)
            NavigationView {
                BleScannerView(viewModel: BleScannerViewModel())
            }
            .tabItem {
                Label("Bluetooth", systemImage: "antenna.radiowaves.left.and.right")
            }
            .tag(Tab.bluetooth)
            NavigationView {
                SettingsView(viewModel: SettingsViewModel(), tabSelection: $tabSelection)
            }
            .tabItem {
                Label("Settings", systemImage: "slider.horizontal.3")
            }
            .tag(Tab.settings)
            NavigationView {
                DukeSettingsView()
            }
            .tabItem {
                Label("Passport", systemImage: "character.book.closed")
            }
            .tag(Tab.passportSettings)
        }
        .accentColor(.brown)
    }
}
