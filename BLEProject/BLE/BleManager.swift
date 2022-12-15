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

enum ConnectionState {
    case disconnected
    case connected
}

class BleManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BleManager()

    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var sonosOnlySearch: Bool = false
    private var peripheralToConnect: CBPeripheral?
    private var dataToWrite: Data?
    private var inCharacteristic: CBCharacteristic?
    private var connectionAttempt = true
    private var isDeviceConnected: ConnectionState = .disconnected {
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
    var dukeModel = DukeModel() {
        didSet {
            NotificationCenter.default.post(name: Constants.Notifications.dukeModelValueChanged,
                                            object: self.dukeModel)
        }
    }

    init(sonosOnlySearch: Bool = false) {
        super.init()
        self.sonosOnlySearch = sonosOnlySearch
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager.scanForPeripherals(withServices: self.sonosOnlySearch ?
                                                   [Constants.ServiceIDs.Sonos.SONOS_GATT_SERVICE_UUID] : nil)
        }
        if central.state == .poweredOff {
            self.centralManager.stopScan()
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // If user pressed "Connect", try connecting to the selected device
        if let peripheralToConnect {
            if peripheralToConnect.identifier == peripheral.identifier {
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
        self.centralManager.stopScan()
        self.isDeviceConnected = .connected
        self.scannedDevices.forEach { deviceModel in
            if deviceModel.peripheral.identifier == self.peripheralToConnect?.identifier {
                self.connectedDevice = deviceModel
            }
        }
        print("Device connected!!!")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Device disconnected!!!!")
        self.isDeviceConnected = .disconnected
        self.connectedDevice = nil
        self.peripheralToConnect = nil
        self.connectionAttempt = true
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }

        for service in services {
            // If the service is Sonos one, discover Sonos characteristics. Otherwise search for general ones.
            if service.uuid == Constants.ServiceIDs.Sonos.SONOS_GATT_SERVICE_UUID {
                service.peripheral?.discoverCharacteristics([Constants.ServiceIDs.Sonos.SONOS_GATT_IN_CHAR_UUID, Constants.ServiceIDs.Sonos.SONOS_GATT_OUT_CHAR_UUID],
                                                             for: service)
            } else {
                service.peripheral?.discoverCharacteristics(Constants.ServiceIDs.characteristicsToDiscover,
                                                            for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }

        for characteristic in characteristics {
            // General characteristics (Battery Level, Device information)
            if Constants.ServiceIDs.characteristicsToDiscover.contains(characteristic.uuid) {
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            }
            // Sonos Out Characteristics
            if Constants.ServiceIDs.Sonos.SONOS_GATT_OUT_CHAR_UUID == characteristic.uuid {
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            }
            // Sonos In Characteristics
            if Constants.ServiceIDs.Sonos.SONOS_GATT_IN_CHAR_UUID == characteristic.uuid {
                self.inCharacteristic = characteristic
                // If it's first connection and peripheral is Duke attempt - fetch current Duke settings
                if self.connectionAttempt && peripheral.name == "Pixel 6a" {
                    self.getDukeCurrentSettings()
                    self.connectionAttempt = false
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if Constants.ServiceIDs.Sonos.SONOS_GATT_OUT_CHAR_UUID == characteristic.uuid {
            self.gattServerCharacteristicsHandler(characteristic: characteristic)
        } else {
            self.handleCharacteristics(characteristic: characteristic)
        }
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
        switch self.isDeviceConnected {
        case .disconnected:
            self.peripheralToConnect = device.peripheral
            // Have to restart scanning process since we stopped it when connected to the device for the first time.
            // If we disconnect and connect again, we need to restart process of scanning until we connect to the device again.
            self.centralManager.scanForPeripherals(withServices: self.sonosOnlySearch ?
                                                   [Constants.ServiceIDs.Sonos.SONOS_GATT_SERVICE_UUID] : nil)
        case .connected:
            self.centralManager.cancelPeripheralConnection(device.peripheral)
        }
    }

    /// Handle characteristics if device is connected.
    /// - Parameters:
    ///   - characteristic: CBCharacteristic
    func handleCharacteristics(characteristic: CBCharacteristic) {
        if let connectedDevice,
           let bleData = connectedDevice.bleData {
            // Verify for each characteristic that BleDeviceModel.bleData doesn't already contain AdvertisementData that we are interested in
            var updatedData = bleData
            if Constants.ServiceIDs.BATTERY_LEVEL == characteristic.uuid &&
                !(bleData.contains(where: {$0.key == AdvertisementDataKeys.characteristicBatteryLevel})) {
                var byte:UInt8 = 0
                characteristic.value?.copyBytes(to: &byte, count: 1)
                let valueInInt = Int(byte)
                updatedData.append(BleData(key: AdvertisementDataKeys.characteristicBatteryLevel,
                                            value: String(valueInInt)))
            }
            if Constants.ServiceIDs.MODEL_NUMBER_STRING == characteristic.uuid &&
                !(bleData.contains(where: {$0.key == AdvertisementDataKeys.characteristicModelName})){
                if let value = characteristic.value {
                    updatedData.append(BleData(key: AdvertisementDataKeys.characteristicModelName,
                                                value: String(data: value, encoding: .utf8) as Any))
                }

            }
            if Constants.ServiceIDs.MANUFACTURER_NAME_STRING == characteristic.uuid &&
                !(bleData.contains(where: {$0.key == AdvertisementDataKeys.characteristicManufacturerName})){
                if let value = characteristic.value {
                    updatedData.append(BleData(key: AdvertisementDataKeys.characteristicManufacturerName,
                                                value: String(data: value, encoding: .utf8) as Any))
                }
            }
            self.connectedDevice = BleDeviceModel(peripheral: connectedDevice.peripheral,
                                                  name: connectedDevice.name,
                                                  bleData: updatedData)
        }
    }

    func gattServerCharacteristicsHandler(characteristic: CBCharacteristic) {
        if let value = characteristic.value {
            // Byte in position "2" holds the information what Setting was called.
            // TODO: Need to expand this for more scenarios when adding more info to local Duke Controller.
            switch value[2] {
            case SettingsCommandId.SETTINGS_GET_DEVICE_NAME.rawValue:
                self.dukeModel.deviceName = String(data: value[4...], encoding: .utf8)
            case SettingsCommandId.SETTINGS_GET_ANC_MODE.rawValue:
                self.dukeModel.ancMode = value[3].boolValue
            case SettingsCommandId.SETTINGS_GET_HEAD_TRACKING_MODE.rawValue:
                self.dukeModel.headTrackingMode = value[3].boolValue
            default:
                break
            }
        }
    }

    func getDukeCurrentSettings() {
        self.writeData(data: Data([CommandType.COMMAND_TYPE_COMMAND.rawValue,
                                                NamespaceId.NAMESPACE_SETTINGS.rawValue,
                                                SettingsCommandId.SETTINGS_GET_DEVICE_NAME.rawValue]))
        self.writeData(data: Data([CommandType.COMMAND_TYPE_COMMAND.rawValue,
                                                NamespaceId.NAMESPACE_SETTINGS.rawValue,
                                                SettingsCommandId.SETTINGS_GET_ANC_MODE.rawValue]))
        self.writeData(data: Data([CommandType.COMMAND_TYPE_COMMAND.rawValue,
                                                NamespaceId.NAMESPACE_SETTINGS.rawValue,
                                                SettingsCommandId.SETTINGS_GET_HEAD_TRACKING_MODE.rawValue]))
    }

    func writeData(data: Data) {
        if self.connectedDevice?.peripheral.state != .connected {
            // Return if trying to writeData to disconnected device
            return
        }
        if let inCharacteristic {
            self.connectedDevice?.peripheral.writeValue(data, for: inCharacteristic, type: .withoutResponse)
            self.connectedDevice?.peripheral.discoverServices([Constants.ServiceIDs.Sonos.SONOS_GATT_SERVICE_UUID])
        }
    }
}

extension UInt8 {
    var boolValue: Bool {
        return self != 0
    }
}
