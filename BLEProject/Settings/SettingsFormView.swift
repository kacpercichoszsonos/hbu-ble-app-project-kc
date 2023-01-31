//
//  SettingsFormView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 25/01/2023.
//

import SwiftUI
import Symphony
import SonosSymphony

struct SettingsFormView: View {
    @StateObject var viewModel: SettingsViewModel
    @State private var deviceName: String = ""
    @State private var ancMode: Bool = false
    @State private var headTrackingMode: Bool = false

    var body: some View {
        Form {
            HStack {
                Text(Constants.Strings.SettingsView.settingsViewProductNameString)
                    .padding(.horizontal)
                TextField(text: $deviceName ,
                          prompt: Text(self.viewModel.dukeModel?.deviceName ?? Constants.Strings.SettingsView.settingsViewProductNameTextfieldPrompt)) {
                    Text("Device name")
                }
                          .onSubmit {
                              self.viewModel.writeData(setting: .deviceName, value: deviceName)
                          }
            }
            HStack {
                Toggle(isOn: $ancMode) {
                    Text(Constants.Strings.SettingsView.settingsViewAncModeString)
                }
                .toggleStyle(
                    ColoredToggleStyle(
                        onColor: .gray,
                        offColor: .gray,
                        thumbColorOn: .brown,
                        thumbColorOff: .white
                    ))
                .onChange(of: ancMode) { value in
                    self.viewModel.writeData(setting: .anc, value: value)
                }
            }
            HStack {
                Toggle(isOn: $headTrackingMode) {
                    Text(Constants.Strings.SettingsView.settingsViewHeadTrackingModeString)
                }
                .toggleStyle(
                    ColoredToggleStyle(
                        onColor: .gray,
                        offColor: .gray,
                        thumbColorOn: .brown,
                        thumbColorOff: .white
                    ))
                .onChange(of: headTrackingMode) { value in
                    self.viewModel.writeData(setting: .headTracking, value: value)
                }
            }
        }.onAppear {
            (self.ancMode, self.headTrackingMode) = self.viewModel.setupView()
        }
    }
}

struct SettingsFormView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsFormView(viewModel: SettingsViewModel())
    }
}
