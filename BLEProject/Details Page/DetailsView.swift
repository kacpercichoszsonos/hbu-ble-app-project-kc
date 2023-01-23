//
//  DetailsView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 16/01/2023.
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var viewModel: DetailsViewModel

    init(device: BleDeviceModel) {
        _viewModel = ObservedObject(wrappedValue: DetailsViewModel(device: device))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.viewModel.device.bleData ?? []) { bleData in
                    VStack(alignment: .leading) {
                        Text(self.viewModel.setupCell(bleData: bleData).title)
                            .padding(.leading, 10)
                            .frame(alignment: .topLeading)
                        Spacer()
                        Text(self.viewModel.setupCell(bleData: bleData).description)
                            .padding(.leading, 20)
                            .frame(alignment: .topLeading)
                    }
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
        }
        .navigationTitle(viewModel.device.name)
        .toolbar {
            ToolbarItem {
                Button(self.viewModel.isConnected == .connected ? Constants.Strings.DetailsView.detailsViewDisconnectButtonString : Constants.Strings.DetailsView.detailsViewConnectButtonString) {
                    self.viewModel.connectionBtnTapped()
                }
            }
        }
    }
}
