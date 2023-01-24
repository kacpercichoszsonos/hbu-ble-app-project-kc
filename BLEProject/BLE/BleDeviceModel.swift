//
//  BleModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 23/11/2022.
//

import Foundation
import CoreBluetooth

struct BleDeviceModel: Identifiable {
    var id: String { name }
    var peripheral: CBPeripheral
    var name: String
    var bleData: [BleData]?
}

struct BleData: Identifiable {
    var id: AdvertisementDataKeys { key }
    var key: AdvertisementDataKeys
    var value: Any
}
