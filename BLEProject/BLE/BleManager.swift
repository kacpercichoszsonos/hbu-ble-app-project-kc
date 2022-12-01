//
//  BLEManager.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 15/11/2022.
//

import Foundation
import CoreBluetooth

/// Enum with advertisementData keys to that we are interested in
enum AdvertisementDataKeys: String, CaseIterable {
    case kCBAdvDataIsConnectable
    case kCBAdvDataLocalName
    case kCBAdvDataServiceUUIDs
    case characteristicBatteryLevel
    case characteristicManufacturerName
    case characteristicModelName
}

class BleManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BleManager()

    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var sonosOnlySearch: Bool = false
    private var peripheralToConnect: CBPeripheral?
    private var isDeviceConnected: Bool = false {
        didSet {
            NotificationCenter.default.post(name: Constants.Notifications.connectedToDevice,
                                            object: self.isDeviceConnected)
        }
    }

    var scannedDevices: [BleDeviceModel] = [] {
        didSet {
            NotificationCenter.default.post(name: Constants.Notifications.scannedDevicesChangedNotification,
                                            object: self.scannedDevices)
        }
    }

    var connectedDevice: BleDeviceModel? {
        didSet {
            NotificationCenter.default.post(name: Constants.Notifications.connectedDeviceValueChanged,
                                            object: self.connectedDevice)
        }
    }

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    init(sonosOnlySearch: Bool) {
        super.init()
        self.sonosOnlySearch = sonosOnlySearch
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager.scanForPeripherals(withServices: self.sonosOnlySearch ?
                                                   [Constants.ServiceIDs.Sonos.SONOS_GATT_SERVICE_UUID] : nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // If user pressed "Connect", try connecting to the selected device
        if let peripheralToConnect {
            if peripheralToConnect.identifier == peripheral.identifier {
                self.centralManager.stopScan()
                self.centralManager.connect(peripheral)
            }

        }
        // Otherwise scan for all devices to display them in Main Menu
        self.peripheral = peripheral
        self.peripheral.delegate = self
        if !self.scannedDevices.contains(where: {$0.name == peripheral.name}) {
            self.scannedDevices.append(BleDeviceModel(peripheral: peripheral,
                                                      name: peripheral.name ?? "Unknown device",
                                                      data: self.filterAdvertisementData(advertisementData: advertisementData)))
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(Constants.ServiceIDs.servicesToDiscover)
        self.isDeviceConnected = true
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Device disconnected!!!!")
        self.isDeviceConnected = false
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }

        for service in services {
            service.peripheral?.discoverCharacteristics(Constants.ServiceIDs.characteristicsToDiscover,
                                                       for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }

        for characteristic in characteristics {
            if Constants.ServiceIDs.characteristicsToDiscover.contains(characteristic.uuid) {
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        self.handleCharacteristics(peripheral: peripheral, characteristic: characteristic)
    }

    /// Filters advertisementData to return only data we are interested in displaying with key as AdvertisementDataKeys
    /// - Parameter advertisementData: data to filter
    /// - Returns: Filtered data as [AdvertisementDataKeys : Any]
    func filterAdvertisementData(advertisementData: [String : Any]) -> [AdvertisementDataKeys : Any] {
        var advertisementArray: [AdvertisementDataKeys : Any] = [:]
        advertisementData.forEach { (key, value) in
            AdvertisementDataKeys.allCases.forEach { enumKey in
                if enumKey.rawValue == key {
                    advertisementArray[enumKey] = value
                }
            }
        }
        return advertisementArray
    }

    func updateConnectionStatus(device: BleDeviceModel) {
        if self.isDeviceConnected {
            self.connectedDevice = nil
            self.centralManager.cancelPeripheralConnection(device.peripheral)
        } else {
            self.connectedDevice = device
            self.peripheralToConnect = device.peripheral
        }
    }

    func handleCharacteristics(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        if let connectedDevice {
            var updatedData = connectedDevice.data
            if Constants.ServiceIDs.BATTERY_LEVEL == characteristic.uuid {
                var byte:UInt8 = 0
                characteristic.value?.copyBytes(to: &byte, count: 1)

                let valueInInt = Int(byte)
                updatedData?[AdvertisementDataKeys.characteristicBatteryLevel] = String(valueInInt)
            }
            if Constants.ServiceIDs.MODEL_NUMBER_STRING == characteristic.uuid {
                if let value = characteristic.value {
                    let string = String(data: value, encoding: .utf8)
                    updatedData?[AdvertisementDataKeys.characteristicModelName] = string
                }

            }
            if Constants.ServiceIDs.MANUFACTURER_NAME_STRING == characteristic.uuid {
                if let value = characteristic.value {
                    let string = String(data: value, encoding: .utf8)
                    updatedData?[AdvertisementDataKeys.characteristicManufacturerName] = string
                }

            }
            self.connectedDevice = BleDeviceModel(peripheral: connectedDevice.peripheral,
                                                  name: connectedDevice.name,
                                                  data: updatedData)
        }
    }
}
