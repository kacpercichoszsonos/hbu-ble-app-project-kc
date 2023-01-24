//
//  DukeControlFormView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 24/01/2023.
//

import SwiftUI
import Symphony

struct DukeControlFormView: View {
    @StateObject var viewModel: DukeControlViewModel
    @State private var deviceName: String = ""
    @State private var ancMode: Bool = false
    @State private var headTrackingMode: Bool = false


    var body: some View {
        Form {
            HStack {
                Text(Constants.Strings.DukeControlView.dukeControlViewProductNameString)
                    .padding(.horizontal)
                TextField(text: $deviceName ,
                          prompt: Text(self.viewModel.dukeModel?.deviceName ?? Constants.Strings.DukeControlView.dukeControlViewProductNameTextfieldPrompt)) {
                    Text("Device name")
                }
                          .onSubmit {
                              self.viewModel.writeData(setting: .deviceName, value: deviceName)
                          }
            }
            HStack {
                Toggle(isOn: $ancMode) {
                    Text(Constants.Strings.DukeControlView.dukeControlViewAncModeString)
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
                    Text(Constants.Strings.DukeControlView.dukeControlViewHeadTrackingModeString)
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

struct DukeControlFormView_Previews: PreviewProvider {
    static var previews: some View {
        DukeControlFormView(viewModel: DukeControlViewModel())
    }
}
