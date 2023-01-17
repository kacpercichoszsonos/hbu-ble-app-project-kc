//
//  TabBarView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 16/01/2023.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            DukeControlView()
                .tabItem {
                    Label("Duke", systemImage: "headphones")
                }
            NavigationView {
                BleScannerView(viewModel: BleScannerViewModel())
            }
            .tabItem {
                Label("Bluetooth", systemImage: "antenna.radiowaves.left.and.right")
            }
        }
    }
}
