//
//  DetailsView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 16/01/2023.
//

import SwiftUI
import Symphony

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
                        ListItem(title: self.viewModel.setupCell(bleData: bleData).title,
                                 subtitle: self.viewModel.setupCell(bleData: bleData).description)
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
        .navigationBarTitleTextColor(.brown)
        .onAppear {
            
        }
        .toolbar {
            ToolbarItem {
                Button(self.viewModel.isConnected == .connected ? Constants.Strings.DetailsView.detailsViewDisconnectButtonString : Constants.Strings.DetailsView.detailsViewConnectButtonString) {
                    self.viewModel.connectionBtnTapped()
                }
            }
        }
    }
}
