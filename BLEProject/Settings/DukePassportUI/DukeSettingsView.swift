//
//  DukeSettingsView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 07/02/2023.
//

import SwiftUI
import SonosSymphony
import Symphony

private let maxCellHeight: CGFloat = 60

struct DukeSettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 5) {
                SymphonyPageHeader(title: self.viewModel.dukeModel?.deviceName ?? "Kacper's Duke", eyebrowText: "Duke", icon: Image("Plus")) {
                    //TODO:
                }
                .foregroundColor(Color.primary)
                .frame(maxWidth: .infinity)
                HeadphonesImageView()
                    .padding(.top, -125)
                if let sections = self.viewModel.loadJson() {
                    ForEach(sections, id: \.header) { setting in
                        SettingsSectionView(viewModel: self.viewModel, section: setting)
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color.sonosBackgroundSecondary.ignoresSafeArea())
    }
}

