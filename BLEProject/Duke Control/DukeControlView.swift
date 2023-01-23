//
//  DukeControlView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 16/01/2023.
//

import SwiftUI

enum CurrentlyUsedSettings {
    case anc
    case headTracking
    case deviceName
}

struct DukeControlView: View {
    @StateObject var viewModel: DukeControlViewModel
    @State private var deviceName: String = ""
    @State private var ancMode: Bool = false
    @State private var headTrackingMode: Bool = false

    var body: some View {
        if self.viewModel.isDukeConnected {
            Form {
                HStack {
                    Text(Constants.Strings.DukeControlView.dukeControlViewProductNameString)
                    TextField(text: $deviceName ,
                              prompt: Text(self.viewModel.dukeModel?.deviceName ?? Constants.Strings.DukeControlView.dukeControlViewProductNameTextfieldPrompt)) {
                        Text("Device name")
                    }.onSubmit {
                        self.viewModel.writeData(setting: .deviceName, value: deviceName)
                    }
                }
                HStack {
                    Toggle(isOn: $ancMode) {
                        Text(Constants.Strings.DukeControlView.dukeControlViewAncModeString)
                    }.onChange(of: ancMode) { value in
                        self.viewModel.writeData(setting: .anc, value: value)
                    }
                }
                HStack {
                    Toggle(isOn: $headTrackingMode) {
                        Text(Constants.Strings.DukeControlView.dukeControlViewHeadTrackingModeString)
                    }.onChange(of: headTrackingMode) { value in
                        self.viewModel.writeData(setting: .headTracking, value: value)
                    }
                }
            }.onAppear {
                (self.ancMode, self.headTrackingMode) = self.viewModel.setupView()
            }
        } else {
            Text(Constants.Strings.DukeControlView.dukeControlViewConnectToDukeString)
        }
    }
}

struct DukeControlView_Previews: PreviewProvider {
    static var previews: some View {
        DukeControlView(viewModel: DukeControlViewModel())
    }
}
