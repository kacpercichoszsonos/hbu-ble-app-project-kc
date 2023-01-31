//
//  MainViewModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 14/11/2022.
//

import Foundation
import SwiftUI

class BleScannerViewModel: ObservableObject {
    private var peripheralsObserver: NSObjectProtocol?
    private var sonosOnlySearch: Bool = false
    @Published var isScanning: Bool = false
    @Published var devices = [BleDeviceModel]()

    init() {
        self.peripheralsObserver = NotificationCenter.default.addObserver(forName: Constants.Notifications.scannedDevicesChangedNotification,
                                                                          object: nil,
                                                                          queue: nil,
                                                                          using: { [weak self] note in
            guard let devices = note.object as? [BleDeviceModel] else {
                return
            }

            self?.devices = devices
        })
    }

    func setSonosOnlySearchBool(_value: Bool) {
        // Reset scanning when SonosOnly switch is changed while already scanning
        if !self.devices.isEmpty {
            self.isScanning = false
            BleManager.shared.stopScanning()
        }
        self.sonosOnlySearch = _value
    }

    func scanningToggle() {
        // Setting short 1 second delay with spinner while loading BLE devices
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isScanning ? BleManager.shared.stopScanning() : BleManager.shared.startScanning(sonosOnly: self.sonosOnlySearch)
            self.isScanning.toggle()
        }
    }
}
