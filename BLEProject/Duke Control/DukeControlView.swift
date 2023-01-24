//
//  DukeControlView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 16/01/2023.
//

import SwiftUI
import Symphony

enum CurrentlyUsedSettings {
    case anc
    case headTracking
    case deviceName
}

struct DukeControlView: View {
    @EnvironmentObject var theme: Theme
    @StateObject var viewModel: DukeControlViewModel
    @State private var deviceName: String = ""
    @State private var ancMode: Bool = false
    @State private var headTrackingMode: Bool = false

    var body: some View {
        if self.viewModel.isDukeConnected {
            VStack(alignment: .center, content: {
                Header(title: Constants.Strings.DukeControlView.dukeControlViewHeaderTitleString)
                    .padding(.horizontal)
                    .foregroundColor(.brown)
                DukeControlFormView(viewModel: self.viewModel)
                ActivityIcon(barCount: 8, gap: 2, size: 124, speed: 0.4)
                    .foregroundColor(.brown)
            })
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
