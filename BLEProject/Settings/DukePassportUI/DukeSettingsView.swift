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
    @State var isPresented: Bool = false
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 5) {
                SymphonyPageHeader(title: self.viewModel.dukeModel?.deviceName ?? "Kacper's Duke", eyebrowText: "Duke", icon: Image("Plus")) {
                  isPresented.toggle()
                }
                .foregroundColor(Color.primary)
                .frame(maxWidth: .infinity)
                HeadphonesImageView()
                    .padding(.top, -100)
                if self.viewModel.isDukeConnected {
                    if let sections = self.viewModel.loadJson() {
                        ForEach(sections, id: \.header) { setting in
                            SettingsSectionView(viewModel: self.viewModel, section: setting)
                        }
                    }
                } else {
                    Spacer()
                    SymphonyButton(Constants.Strings.SettingsView.settingsViewConnectToDukeString) {
                        self.viewModel.connectDuke()
                    }
                    .buttonStyle(.symphonyPrimary)
                    Spacer()
                }
            }
            .padding(.horizontal)
            .sheet(isPresented: $isPresented) {
                SheetView(viewModel: self.viewModel, headerTitle: "Add to Duke")
                    .symphonyCard {}
            }.padding()
        }
        .background(Color.sonosBackgroundSecondary.ignoresSafeArea())
    }
}

