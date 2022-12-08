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

    init(sonosOnlySearch: Bool? = false) {
        super.init()
        if let sonosOnlySearch {
            self.sonosOnlySearch = sonosOnlySearch
        }
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
        if !self.scannedDevices.contains(where: {$0.peripheral.identifier == peripheral.identifier}) {
            self.scannedDevices.append(BleDeviceModel(peripheral: peripheral,
                                                      name: peripheral.name ?? "Unknown device",
                                                      bleData: self.filterAdvertisementData(advertisementData: advertisementData)))
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(Constants.ServiceIDs.servicesToDiscover)
        self.isDeviceConnected = true
        self.scannedDevices.forEach { deviceModel in
            if deviceModel.peripheral.identifier == self.peripheralToConnect?.identifier {
                self.connectedDevice = deviceModel
            }
        }
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
        self.handleCharacteristics(characteristic: characteristic)
    }

    /// Filters advertisementData to return only data we are interested in displaying with key as AdvertisementDataKeys
    /// - Parameter advertisementData: data to filter
    /// - Returns: Filtered data as [BleData]
    func filterAdvertisementData(advertisementData: [String : Any]) -> [BleData]? {
        var bleData = [BleData]()
        advertisementData.forEach { (key, value) in
            AdvertisementDataKeys.allCases.forEach { enumKey in
                if enumKey.rawValue == key {
                    bleData.append(BleData(key: enumKey, value: value))
                }
            }
        }
        return bleData
    }

    /// Disconnect device if connected and connect if not.
    /// - Parameter device: Device to connect/disconnect to
    func updateConnectionStatus(device: BleDeviceModel) {
        if self.isDeviceConnected {
            self.connectedDevice = nil
            self.centralManager.cancelPeripheralConnection(device.peripheral)
        } else {
            self.peripheralToConnect = device.peripheral
            // Have to restart scanning process since we stopped it when connected to the device for the first time.
            // If we disconnect and connect again, we need to restart process of scanning until we connect to the device again.
            self.centralManager.scanForPeripherals(withServices: self.sonosOnlySearch ?
                                                   [Constants.ServiceIDs.Sonos.SONOS_GATT_SERVICE_UUID] : nil)
        }
    }

    /// Handle characteristics if device is connected.
    /// - Parameters:
    ///   - characteristic: CBCharacteristic
    func handleCharacteristics(characteristic: CBCharacteristic) {
        if let connectedDevice {
            var updatedData = connectedDevice.bleData
            if Constants.ServiceIDs.BATTERY_LEVEL == characteristic.uuid {
                var byte:UInt8 = 0
                characteristic.value?.copyBytes(to: &byte, count: 1)
                let valueInInt = Int(byte)
                updatedData?.append(BleData(key: AdvertisementDataKeys.characteristicBatteryLevel,
                                            value: String(valueInInt)))
            }
            if Constants.ServiceIDs.MODEL_NUMBER_STRING == characteristic.uuid {
                if let value = characteristic.value {
                    updatedData?.append(BleData(key: AdvertisementDataKeys.characteristicModelName,
                                                value: String(data: value, encoding: .utf8) as Any))
                }

            }
            if Constants.ServiceIDs.MANUFACTURER_NAME_STRING == characteristic.uuid {
                if let value = characteristic.value {
                    updatedData?.append(BleData(key: AdvertisementDataKeys.characteristicManufacturerName,
                                                value: String(data: value, encoding: .utf8) as Any))
                }

            }
            self.connectedDevice = BleDeviceModel(peripheral: connectedDevice.peripheral,
                                                  name: connectedDevice.name,
                                                  bleData: updatedData)
        }
    }
}
