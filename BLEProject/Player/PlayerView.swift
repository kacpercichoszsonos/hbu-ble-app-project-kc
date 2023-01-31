//
//  PlayerView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 25/01/2023.
//

import SwiftUI
import Symphony
import SonosSymphony

struct PlayerView: View {
    @StateObject var viewModel: PlayerViewModel
    @Binding var tabSelection: Tab
    @State private var songProgress: Float = 40
    @State private var isMuted = false
    @State private var volume: Float = 100
    static let theme = Theme.example

    var body: some View {
        VStack {
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
                GridItem(title: "Jubilee Street", subtitle: "Nick Cave and The Bad Seeds") {
                    CustomImage(image: "https://upload.wikimedia.org/wikipedia/en/f/f3/Push_the_Sky_Away.jpg", width: .infinity, height: 250)
                        .aspectRatio(contentMode: .fit)
                }
                VStack {
                    SymphonyRangeSlider(value: $songProgress, isMuted: $isMuted)
                    HStack{
                        Text("0:45")
                        Spacer()
                        Text("-3:30")
                    }
                }
                .padding(.horizontal)
                Spacer()
                Spacer()
                PlayPauseView(viewModel: self.viewModel)
                    .padding(.horizontal)
                Spacer()
            } else {
                Spacer()
                Button(action: {BleManager.shared.searchForDukeOnly()}) {
                    Text(Constants.Strings.SettingsView.settingsViewConnectToDukeString)
                        .padding(5)
                }
                .buttonStyle(SecondaryButton(background: .brown))
                .buttonBorderShape(.roundedRectangle)
                Spacer()
            }
        }
        .padding(.horizontal)
        .environmentObject(PlayerView.theme)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(viewModel: PlayerViewModel(), tabSelection: .constant(.settings))
    }
}
