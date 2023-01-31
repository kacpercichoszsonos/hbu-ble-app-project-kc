//
//  PlayPauseComponent.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 25/01/2023.
//

import SwiftUI
import Symphony

struct PlayPauseView: View {
    @StateObject var viewModel: PlayerViewModel
    @State private var previousTrack: Bool = false
    @State private var skipTrack: Bool = false
    @State private var play: Bool = true

    var body: some View {
        HStack {
            Icon(name: "repeat")
            Spacer()
            Icon(name: "backward.end")
                .onTapGesture {
                    self.viewModel.writeData(setting: .previousTrack)
                }
            Spacer()
            Icon(name: self.play ? "pause.circle" : "play.circle", size: 60)
                .onTapGesture {
                    self.play.toggle()
                }
                .onChange(of: play) { value in
                    self.viewModel.writeData(setting: .playPause, value: value)
                }
            Spacer()
            Icon(name: "forward.end")
                .onTapGesture {
                    self.viewModel.writeData(setting: .skipTrack)
                }
            Spacer()
            Icon(name: "shuffle")
        }
    }
}

struct PlayPauseView_Previews: PreviewProvider {
    static var previews: some View {
        PlayPauseView(viewModel: PlayerViewModel() )
    }
}
