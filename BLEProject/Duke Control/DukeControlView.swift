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
                    Text("Product name: ")
                    TextField(text: $deviceName ,
                              prompt: Text(self.viewModel.dukeModel?.deviceName ?? "Enter device name")) {
                        Text("Device name")
                    }.onSubmit {
                        self.viewModel.writeData(setting: .deviceName, value: deviceName)
                    }
                }
                HStack {
                    Toggle(isOn: $ancMode) {
                        Text("ANC Mode: ")
                    }.onChange(of: ancMode) { value in
                        self.viewModel.writeData(setting: .anc, value: value)
                    }
                }
                HStack {
                    Toggle(isOn: $headTrackingMode) {
                        Text("Head tracking Mode: ")
                    }.onChange(of: headTrackingMode) { value in
                        self.viewModel.writeData(setting: .headTracking, value: value)
                    }
                }
            }.onAppear {
                self.setupView()
            }
        } else {
            Text("Connect to Duke")
        }
    }

    private func setupView() {
        guard let dukeModel = self.viewModel.dukeModel,
              let ancMode = dukeModel.ancMode,
              let headTrackingMode = dukeModel.headTrackingMode else {
            return
        }

        self.ancMode = ancMode
        self.headTrackingMode = headTrackingMode
    }
}

struct DukeControlView_Previews: PreviewProvider {
    static var previews: some View {
        DukeControlView(viewModel: DukeControlViewModel())
    }
}
