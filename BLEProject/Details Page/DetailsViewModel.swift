//
//  DetailsViewModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 17/11/2022.
//

import Foundation

class DetailsViewModel: ViewModel, ViewModelProtocol {
    var device: BleDeviceModel
    var connectionObserver: NSObjectProtocol?

    var isConnected: Bool = false {
        didSet {
            self.update?(.reload)
        }
    }

    var update: ((DetailsViewModel.UpdateType) -> Void)?
    enum UpdateType {
        case reload
        case loading
    }

    init(device: BleDeviceModel) {
        self.device = device
        super.init()
        self.isDeviceConnected()
    }

    func isDeviceConnected () {
        self.connectionObserver = NotificationCenter.default.addObserver(forName: Constants.Notifications.connectedToDevice,
                                                                          object: nil,
                                                                          queue: nil,
                                                                          using: { [weak self] note in
            self?.isConnected = note.object as! Bool
        })
    }

    func connectionBtnTapped() {
        BleManager.shared.updateConnectionStatus(peripheral: self.device.peripheral)
        self.update?(.loading)
    }
}
