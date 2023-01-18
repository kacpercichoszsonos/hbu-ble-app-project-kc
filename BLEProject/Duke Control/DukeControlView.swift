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
    @State private var deviceName = ""

    var body: some View {
        Text("Connect to Duke")
        Form {
            TextField(text: $deviceName ,prompt: Text("Enter device name")) {
                Text("Device name")
            }
        }
    }
}

struct DukeControlView_Previews: PreviewProvider {
    static var previews: some View {
        DukeControlView()
    }
}
