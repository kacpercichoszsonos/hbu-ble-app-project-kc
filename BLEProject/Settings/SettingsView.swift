//
//  SettingsView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 25/01/2023.
//

import SwiftUI
import Symphony
import SonosSymphony

enum SettingsTypes {
    case anc
    case headTracking
    case deviceName
    case volume
    case sonosSpatial
}

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    @Binding var tabSelection: Tab
    static let theme = Theme.example
    @State private var volumeLimitSlider: Float = 100.0
    @State private var isMuted: Bool = false

    var body: some View {
        VStack(alignment: .center, content: {
            HStack(spacing: 10) {
                Header(title: Constants.Strings.SettingsView.settingsViewHeaderTitleString)
                    .foregroundColor(.brown)
                Icon(name: self.viewModel.getSpeakerIconName())
                    .onTapGesture {
                        self.viewModel.toggleDukePairing()
                    }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            if self.viewModel.isDukeConnected {
                SettingsFormView(viewModel: self.viewModel)
                ActivityIcon(barCount: 30, gap: 2, size: $volumeLimitSlider, speed: 0.4)
                    .padding(.horizontal)
                    .foregroundColor(.brown)
                HStack(spacing: 10) {
                    Icon(name: self.viewModel.volumeIcon(sliderValue: volumeLimitSlider))
                    SymphonyRangeSlider(value: $volumeLimitSlider, isMuted: $isMuted)
                        .onChange(of: volumeLimitSlider) { newValue in
                            self.viewModel.writeData(setting: .volume, value: newValue)
                        }
                    Text("\(Int(volumeLimitSlider))")
                }
                .padding(.horizontal)
            } else {
                Spacer()
                Button(action: {self.viewModel.connectDuke()}) {
                    Text(Constants.Strings.SettingsView.settingsViewConnectToDukeString)
                        .padding(5)
                }
                .buttonStyle(SecondaryButton(background: .brown))
                .buttonBorderShape(.roundedRectangle)
                Spacer()
            }
        })
        .onReceive(self.viewModel.$dukeModel, perform: { dukeModel in
            self.volumeLimitSlider = self.viewModel.setupVolumeSlider()
        })
        .onChange(of: self.viewModel.isDukeConnected, perform: { _ in
            self.volumeLimitSlider = self.viewModel.setupVolumeSlider()
        })
        .padding(.horizontal)
        .frame(maxHeight: .infinity, alignment: .top)
        .environmentObject(SettingsView.theme)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView( viewModel: SettingsViewModel(), tabSelection: .constant(.duke))
    }
}
