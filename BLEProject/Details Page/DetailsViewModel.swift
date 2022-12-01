//
//  DetailsViewModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 17/11/2022.
//

import Foundation

class DetailsViewModel: ViewModel, ViewModelProtocol {
    var device: BleDeviceModel {
        didSet {
            self.update?(.reload)
        }
    }

    var isConnected: Bool = false {
        didSet {
            self.update?(.reload)
        }
    }

    var connectionObserver: NSObjectProtocol?
    var connectedDeviceObserver: NSObjectProtocol?

    var update: ((DetailsViewModel.UpdateType) -> Void)?
    enum UpdateType {
        case reload
        case loading
    }

    init(device: BleDeviceModel) {
        self.device = device
        super.init()
        self.isDeviceConnected()
        self.connectedDeviceValueChanged()
    }

    func isDeviceConnected () {
        self.connectionObserver = NotificationCenter.default.addObserver(forName: Constants.Notifications.connectedToDevice,
                                                                          object: nil,
                                                                          queue: nil,
                                                                          using: { [weak self] note in
            self?.isConnected = note.object as! Bool
        })
    }

    func connectedDeviceValueChanged() {
        self.connectedDeviceObserver = NotificationCenter.default.addObserver(forName: Constants.Notifications.connectedDeviceValueChanged,
                                                                         object: nil,
                                                                         queue: nil,
                                                                         using: { [weak self] note in
            // If object is of connectedDevice is nil don't do anything
            if note.object != nil {
                self?.device = note.object as! BleDeviceModel
            }
        })
    }

    func connectionBtnTapped() {
        BleManager.shared.updateConnectionStatus(device: self.device)
        self.update?(.loading)
    }
}
