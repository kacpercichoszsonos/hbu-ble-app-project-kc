//
//  DukeControlViewModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 13/12/2022.
//

import Foundation

class DukeControlViewModel: ObservableObject {
    @Published var dukeModel: DukeModel? {
        didSet {
            self.isDukeConnected = (dukeModel != nil) ? true : false
        }
    }
    @Published var isDukeConnected: Bool = false
    var dukeModelObserver: NSObjectProtocol?

    init() {
        self.dukeModelValueChanged()
    }

    func writeData(setting: CurrentlyUsedSettings, value: Any?) {
        switch setting {
        case .anc:
            BleManager.shared.writeData(data: Data([CommandType.COMMAND_TYPE_COMMAND.rawValue,
                                                    NamespaceId.NAMESPACE_SETTINGS.rawValue,
                                                    SettingsCommandId.SETTINGS_SET_ANC_MODE.rawValue,
                                                    value as? Bool ?? false ? CommandPduType.COMMAND_PDU_ON.rawValue : CommandPduType.COMMAND_PDU_OFF.rawValue]))
        case .headTracking:
            BleManager.shared.writeData(data: Data([CommandType.COMMAND_TYPE_COMMAND.rawValue,
                                                    NamespaceId.NAMESPACE_SETTINGS.rawValue,
                                                    SettingsCommandId.SETTINGS_SET_HEAD_TRACKING_MODE.rawValue,
                                                    value as? Bool ?? false ? CommandPduType.COMMAND_PDU_ON.rawValue : CommandPduType.COMMAND_PDU_OFF.rawValue]))
        case .deviceName:
            guard let deviceNameString = value as? String else {
                return
            }

            var dataToWrite = Data([CommandType.COMMAND_TYPE_COMMAND.rawValue,
                                    NamespaceId.NAMESPACE_SETTINGS.rawValue,
                                    SettingsCommandId.SETTINGS_SET_DEVICE_NAME.rawValue,
                                    UInt8(deviceNameString.count)])
            deviceNameString.utf8.forEach { byte in
                dataToWrite.append(byte)
            }
            BleManager.shared.writeData(data: dataToWrite)
        }
    }

    private func dukeModelValueChanged() {
        self.dukeModelObserver = NotificationCenter.default.addObserver(forName: Constants.Notifications.dukeModelValueChanged,
                                                                        object: nil,
                                                                        queue: nil,
                                                                        using: { [weak self] note in
            // If object is of dukeModel is nil don't do anything
            if let dukeObject = note.object as? DukeModel,
               dukeObject.deviceName != nil,
               dukeObject.ancMode != nil,
               dukeObject.headTrackingMode != nil {
                self?.dukeModel = dukeObject
            }
        })
    }

    func setupView() -> (ancMode: Bool, headTrackingMode: Bool) {
        if let dukeModel = self.dukeModel,
           let ancMode = dukeModel.ancMode,
           let headTrackingMode = dukeModel.headTrackingMode {
            return (ancMode, headTrackingMode)
        }
        return (false, false)
    }
}
