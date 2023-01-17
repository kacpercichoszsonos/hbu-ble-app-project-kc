//
//  BleScannerView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 12/01/2023.
//

import SwiftUI

struct BleScannerView: View {
    @StateObject private var viewModel: BleScannerViewModel

    init(viewModel: BleScannerViewModel) {
        _viewModel = StateObject(wrappedValue: BleScannerViewModel())
    }

    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Toggle("Search for Sonos only devices", isOn: $viewModel.sonosOnlySearch)
                .onChange(of: self.viewModel.sonosOnlySearch) { newValue in
                    self.viewModel.setSonosOnlySearchBool(_value: newValue)
                }
                .padding(20)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Button(action: self.viewModel.startScanning) {
                Text("Start scanning")
                    .padding(5)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            List() {
                ForEach(self.viewModel.devices) { device in
                    let detailsViewModel = DetailsViewModel(device: device)
                    NavigationLink(destination: DetailsView(viewModel: detailsViewModel)) {
                        Text(device.name)
                    }
                }
            }
        }
    }
}

struct BleScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BleScannerView(viewModel: BleScannerViewModel())
    }
}