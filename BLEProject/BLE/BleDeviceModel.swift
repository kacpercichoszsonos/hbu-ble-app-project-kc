//
//  BleModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 23/11/2022.
//

import Foundation
import CoreBluetooth

struct BleDeviceModel {
    var peripheral: CBPeripheral
    var name: String?
    var data: [AdvertisementDataKeys : Any]?
    var bleData: [BleData]?
}

struct BleData {
    var key: AdvertisementDataKeys
    var value: Any
}
