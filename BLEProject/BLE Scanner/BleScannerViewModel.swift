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

    @Published var devices = [BleDeviceModel]()

    init() {
        self.peripheralsObserver = NotificationCenter.default.addObserver(forName: Constants.Notifications.scannedDevicesChangedNotification,
                                                                          object: nil,
                                                                          queue: nil,
                                                                          using: { [weak self] note in
            self?.devices = note.object as! [BleDeviceModel]
        })
    }

    func setSonosOnlySearchBool(_value: Bool) {
        self.sonosOnlySearch = _value
    }

    func startScanning() {
        // Setting short 1 second delay with spinner while loading BLE devices
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            BleManager.shared.startScanning(sonosOnly: self.sonosOnlySearch)
        }
    }
}
