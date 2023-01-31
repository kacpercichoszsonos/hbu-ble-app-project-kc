//
//  DetailsViewModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 17/11/2022.
//

import Foundation
import CoreBluetooth

class DetailsViewModel: ObservableObject {
    @Published var device: BleDeviceModel
    @Published var isConnected: ConnectionState = .disconnected

    var connectionObserver: NSObjectProtocol?
    var connectedDeviceObserver: NSObjectProtocol?

    init(device: BleDeviceModel) {
        self.device = device
        self.isDeviceConnected()
        self.connectedDeviceValueChanged()
    }

    func isDeviceConnected () {
        self.connectionObserver = NotificationCenter.default.addObserver(forName: Constants.Notifications.connectedToDevice,
                                                                          object: nil,
                                                                          queue: nil,
                                                                          using: { [weak self] note in
            self?.isConnected = note.object as! ConnectionState
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
    }

    func setupCell(bleData: BleData?) -> (title: String, description: String) {
        switch bleData?.key {
        case .kCBAdvDataIsConnectable:
            return (title: "Is device connectable?", description: String(bleData?.value as? Bool ?? false).capitalized)
        case .kCBAdvDataLocalName:
            return (title: "Device name:", description: bleData?.value as? String ?? "")
        case .kCBAdvDataServiceUUIDs:
            return (title: "Service UUID:", description: ((bleData?.value as? Array<Any>)?.first as? CBUUID)!.uuidString)
        case .characteristicBatteryLevel:
            return (title: "Battery level:", description: bleData?.value as? String ?? "")
        case .characteristicManufacturerName:
            return (title: "Manufacturer Name:", description: bleData?.value as? String ?? "")
        case .characteristicModelName:
            return (title: "Model Name: ", description: bleData?.value as? String ?? "")
        case .none:
            // In case for some reason we will get some data without the known key, let's populate cell with N/A
            return (title: "N/A", description: "N/A")
        }
    }
}
