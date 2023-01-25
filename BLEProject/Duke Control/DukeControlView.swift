//
//  DukeControlView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 16/01/2023.
//

import SwiftUI
import Symphony
import SonosSymphony

enum CurrentlyUsedSettings {
    case anc
    case headTracking
    case deviceName
    case volumeLimit
}

struct DukeControlView: View {
    @StateObject var viewModel: DukeControlViewModel
    @Binding var tabSelection: Tab
    static let theme = Theme.example
    @State private var volumeLimitSlider: Float = 100.0
    @State private var isMuted: Bool = false

    var body: some View {
        VStack(alignment: .center, content: {
            HStack(spacing: 10) {
                Header(title: Constants.Strings.DukeControlView.dukeControlViewHeaderTitleString)
                    .foregroundColor(.brown)
                Icon(name: self.viewModel.getSpeakerIconName())
                    .onTapGesture {
                        self.viewModel.toggleDukePairing()
                    }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            if self.viewModel.isDukeConnected {
                DukeControlFormView(viewModel: self.viewModel)
                ActivityIcon(barCount: 30, gap: 2, size: CGFloat(volumeLimitSlider), speed: 0.4)
                    .padding(.horizontal)
                    .foregroundColor(.brown)
                    .frame(minHeight: CGFloat(volumeLimitSlider))
                HStack(spacing: 10) {
                    Icon(name: self.viewModel.volumeIcon(sliderValue: volumeLimitSlider))
                    SymphonyRangeSlider(value: $volumeLimitSlider, isMuted: $isMuted)
                        .onChange(of: volumeLimitSlider) { newValue in
                            self.viewModel.writeData(setting: .volumeLimit, value: newValue)
                        }
                    Text("\(Int(volumeLimitSlider))")
                }
                .padding(.horizontal)
            } else {
                Spacer()
                Button(action: {self.viewModel.connectDuke()}) {
                    Text(Constants.Strings.DukeControlView.dukeControlViewConnectToDukeString)
                        .padding(5)
                }
                .buttonStyle(SecondaryButton(background: .brown))
                .buttonBorderShape(.roundedRectangle)
                Spacer()
            }
        })
        .onChange(of: self.viewModel.isDukeConnected, perform: { _ in
            self.volumeLimitSlider = self.viewModel.setupVolumeSlider()
        })
        .frame(maxHeight: .infinity, alignment: .top)
        .environmentObject(DukeControlView.theme)
    }
}

struct DukeControlView_Previews: PreviewProvider {
    static var previews: some View {
        DukeControlView(viewModel: DukeControlViewModel(), tabSelection: .constant(Tab.duke))
    }
}
