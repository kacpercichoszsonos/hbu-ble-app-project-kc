//
//  MainViewModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 14/11/2022.
//

import Foundation

class MainViewModel: ViewModel, ViewModelProtocol {
    private var ble: BleManager?
    private var peripheralsObserver: NSObjectProtocol?
    private var sonosOnlySearch: Bool?

    var update: ((MainViewModel.UpdateType) -> Void)?
    enum UpdateType {
        case landing
        case loading
        case reload
    }

    var devices: [BleDeviceModel]? {
        didSet {
            self.update?(.reload)
        }
    }

    override init() {
        super.init()
        self.peripheralsObserver = NotificationCenter.default.addObserver(forName: Constants.Notifications.scannedDevicesChangedNotification,
                                                                          object: nil,
                                                                          queue: nil,
                                                                          using: { [weak self] note in
            self?.devices = note.object as? [BleDeviceModel]
        })
    }

    func setSonosOnlySearchBool(_value: Bool) {
        self.sonosOnlySearch = _value
    }

    func startScanning() {
        // Setting short 1 second delay with spinner while loading BLE devices
        self.update?(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.ble = BleManager(sonosOnlySearch: self.sonosOnlySearch ?? false)
        }
    }
}
