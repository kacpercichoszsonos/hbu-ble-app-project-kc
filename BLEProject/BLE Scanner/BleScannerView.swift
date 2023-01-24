//
//  BleScannerView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 12/01/2023.
//

import SwiftUI
import Symphony
import DynamicColor

struct BleScannerView: View {
    static let theme = Theme.example
    @StateObject private var viewModel: BleScannerViewModel
    @State private var sonosOnlySearch: Bool = false

    init(viewModel: BleScannerViewModel) {
        _viewModel = StateObject(wrappedValue: BleScannerViewModel())
    }

    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Toggle(isOn: $sonosOnlySearch) {
                Text(Constants.Strings.BleScannerView.bleScannerViewToggleString)
            }
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .gray,
                    offColor: .gray,
                    thumbColorOn: .brown,
                    thumbColorOff: Color(DynamicColor(BleScannerView.theme.primary).shaded())
                ))
            .onChange(of: sonosOnlySearch) { value in
                self.viewModel.setSonosOnlySearchBool(_value: value)
            }
            Button(action: self.viewModel.startScanning) {
                Text(Constants.Strings.BleScannerView.bleScannerViewStartScanningButtonString)
                    .padding(5)
            }
            .buttonStyle(PrimaryButton(background: .brown))
            .buttonBorderShape(.roundedRectangle)
            List() {
                ForEach(self.viewModel.devices) { device in
                    NavigationLink(destination: DetailsView(device: device)) {
                        ListItem(title: device.name)
                    }
                }
            }
        }
        .environmentObject(BleScannerView.theme)
    }
}

struct BleScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BleScannerView(viewModel: BleScannerViewModel())
    }
}
