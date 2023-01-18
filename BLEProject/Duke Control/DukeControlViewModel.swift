//
//  DukeControlViewModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 13/12/2022.
//

import Foundation

class DukeControlViewModel: ObservableObject {
    var dukeModel: DukeModel?
    var dukeModelObserver: NSObjectProtocol?
    var isDukeConnected: Bool = true

    init() {
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
            if note.object != nil {
                self?.dukeModel = note.object as? DukeModel
            }
        })
    }
}
