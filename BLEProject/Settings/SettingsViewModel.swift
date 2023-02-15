//
//  SettingsViewModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 25/01/2023.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var dukeModel: DukeModel? {
        didSet {
            self.isDukeConnected = (dukeModel != nil) ? true : false
            if self.isDukeConnected {
                BleManager.shared.stopScanning()
            }
        }
    }
    @Published var isDukeConnected: Bool = false
    var dukeModelObserver: NSObjectProtocol?

    init() {
        self.dukeModelValueChanged()
    }

    func writeData(setting: SettingsTypes, value: Any?) {
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
        case .volume:
            guard let volumeFloat = value as? Float else {
                return
            }

            BleManager.shared.writeData(data: Data([CommandType.COMMAND_TYPE_COMMAND.rawValue,
                                                    NamespaceId.NAMESPACE_VOLUME.rawValue,
                                                    VolumeCommandId.VOLUME_SET_VOLUME.rawValue,
                                                    UInt8(Int(volumeFloat))]))
        case .sonosSpatial:
            BleManager.shared.writeData(data: Data([CommandType.COMMAND_TYPE_COMMAND.rawValue,
                                                    NamespaceId.NAMESPACE_SETTINGS.rawValue,
                                                    SettingsCommandId.SETTINGS_SET_SPATIAL_AUDIO_MODE.rawValue,
                                                    value as? Bool ?? false ? CommandPduType.COMMAND_PDU_ON.rawValue : CommandPduType.COMMAND_PDU_OFF.rawValue]))
        }
    }

    private func dukeModelValueChanged() {
        self.dukeModelObserver = NotificationCenter.default.addObserver(forName: Constants.Notifications.dukeModelValueChanged,
                                                                        object: nil,
                                                                        queue: nil,
                                                                        using: { [weak self] note in

            // If passed Duke object is nil, set isDukeConnected to false and return to change the DukeControlView to "Connect to Duke".
            // else check if all settings are loaded and set the self.dukeModel.
            guard let dukeObject = note.object as? DukeModel else {
                self?.isDukeConnected = false
                return
            }

            if dukeObject.deviceName != nil,
               dukeObject.ancMode != nil,
               dukeObject.headTrackingMode != nil,
               dukeObject.volume != nil {
                self?.dukeModel = dukeObject
            }
        })
    }

    func connectDuke() {
        BleManager.shared.searchForDukeOnly()
    }

    func toggleDukePairing() {
        self.isDukeConnected ? BleManager.shared.disconnectDuke() : self.connectDuke()
    }

    func setupView() -> (ancMode: Bool, headTrackingMode: Bool) {
        if let dukeModel = self.dukeModel,
           let sonosSpatial = dukeModel.sonosSpatial,
           let headTrackingMode = dukeModel.headTrackingMode {
            return (sonosSpatial, headTrackingMode)
        }
        return (false, false)
    }

    func setupVolumeSlider() -> Float {
        if let volumeLimit = self.dukeModel?.volume {
            return CFloat(volumeLimit)
        }
        return 100.0
    }

    func getSpeakerIconName() -> String {
        return self.isDukeConnected ? "hifispeaker.fill" : "hifispeaker"
    }

    func volumeIcon(sliderValue: Float) -> String {
        if sliderValue == 0.0 {
            return "speaker"
        }
        if sliderValue < 30 {
            return "speaker.wave.1"
        }
        if sliderValue < 60 {
            return "speaker.wave.2"
        }
        return "speaker.wave.3"
    }

    func loadJson() -> [Section]? {
        if let url = Bundle.main.url(forResource: "settings(1)", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try JSONDecoder().decode(Settings.self, from: data)
                return jsonData.sections
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
