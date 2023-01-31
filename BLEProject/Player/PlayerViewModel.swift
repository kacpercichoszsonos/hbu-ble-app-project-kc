//
//  PlayerViewModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 25/01/2023.
//

import Foundation

enum PlayerWriteDataTypes {
    case playPause
    case skipTrack
    case previousTrack
}

class PlayerViewModel: ObservableObject {
    @Published var isDukeConnected: Bool = false
    var dukeModelObserver: NSObjectProtocol?

    init() {
        self.dukeModelValueChanged()
    }

    func writeData(setting: PlayerWriteDataTypes, value: Any? = nil) {
        switch setting {
        case .playPause:
            BleManager.shared.writeData(data: Data([CommandType.COMMAND_TYPE_COMMAND.rawValue,
                                                    NamespaceId.NAMESPACE_PLAYBACK.rawValue,
                                                    value as? Bool ?? false ? PlaybackCommandId.PLAYBACK_PLAY.rawValue : PlaybackCommandId.PLAYBACK_PAUSE.rawValue]))
        case .skipTrack:
            BleManager.shared.writeData(data: Data([CommandType.COMMAND_TYPE_COMMAND.rawValue,
                                                    NamespaceId.NAMESPACE_PLAYBACK.rawValue,
                                                    PlaybackCommandId.PLAYBACK_SKIP_NEXT.rawValue]))
        case .previousTrack:
            BleManager.shared.writeData(data: Data([CommandType.COMMAND_TYPE_COMMAND.rawValue,
                                                    NamespaceId.NAMESPACE_PLAYBACK.rawValue,
                                                    PlaybackCommandId.PLAYBACK_SKIP_PREV.rawValue]))
        }
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

    func toggleDukePairing() {
        self.isDukeConnected ? BleManager.shared.disconnectDuke() : BleManager.shared.searchForDukeOnly()
    }

    func getSpeakerIconName() -> String {
        return self.isDukeConnected ? "hifispeaker.fill" : "hifispeaker"
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
                self?.isDukeConnected = true
                BleManager.shared.stopScanning()
            }
        })
    }
}
