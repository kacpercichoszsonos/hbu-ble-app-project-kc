//
//  Constants.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 17/11/2022.
//

import Foundation
import CoreBluetooth


struct Constants {
    struct ServiceIDs {
        static let servicesToDiscover = [Sonos.SONOS_GATT_SERVICE_UUID, BATTERY_SERVICE, DEVICE_INFORMATION]
        static let characteristicsToDiscover = [Sonos.SONOS_GATT_IN_CHAR_UUID, Sonos.SONOS_GATT_OUT_CHAR_UUID, BATTERY_LEVEL, MODEL_NUMBER_STRING, MANUFACTURER_NAME_STRING]
        struct Sonos {
            static let SONOS_GATT_SERVICE_UUID = CBUUID(string: "FE07")
            static let SONOS_GATT_IN_CHAR_UUID = CBUUID(string: "C44F42B1-F5CF-479B-B515-9F1BB0099C98")
            static let SONOS_GATT_OUT_CHAR_UUID = CBUUID(string: "C44F42B1-F5CF-479B-B515-9F1BB0099C99")
            static let BLE_TEST_CONTROLLER_PERIPHERAL_ID = "DEADBEEFFEED"
            static let BLE_TEST_MOCK_PERIPHERAL_ID = "CAFEFACEFEED"
            static let BLE_TEST_GATT_SERVER_ID = "FCFFAFEDB3BF33D7E9"
        }
        static let BATTERY_SERVICE = CBUUID(string:"0x180F")
        static let BATTERY_LEVEL = CBUUID(string: "0X2A19")
        static let DEVICE_INFORMATION = CBUUID(string: "0x180A")
        static let MODEL_NUMBER_STRING = CBUUID(string: "0x2A24")
        static let MANUFACTURER_NAME_STRING = CBUUID(string: "0x2A29")
    }

    struct Notifications {
        static let scannedDevicesChangedNotification = Notification.Name("scannedDevicesChanged")
        static let connectedToDevice = Notification.Name("connectedToDevice")
        static let connectedDeviceValueChanged = Notification.Name("connectedDeviceValueChanged")
    }
}

enum CommandType: UInt8 {
    case COMMAND_TYPE_COMMAND = 0x00
    case COMMAND_TYPE_NOTIFICATION = 0x01
    case COMMAND_TYPE_RESPONSE = 0x02
    case COMMAND_TYPE_ERROR = 0x80
}

enum NamespaceId: UInt8 {
    case NAMESPACE_HEADPHONE_STATUS = 0x00
    case NAMESPACE_HEADPHONE_MANAGEMENT = 0x01
    case NAMESPACE_SETTINGS = 0x02
    case NAMESPACE_VOLUME = 0x03
    case NAMESPACE_PLAYBACK = 0x04
    case NAMESPACE_PLAYBACK_METADATA = 0x05
    case NAMESPACE_SOUND_SWAP = 0x06
}

enum CommandId: UInt8 {
    case SUBSCRIBE = 0x01
    case UNSUBSCRIBE = 0x02
}

enum HeadphoneStatusCommandId: UInt8 {
    //Namespace: Headphone status

    case STATUS_GET_INFO = 0x03
    case STATUS_GET_BATTERY_STATUS = 0x04
    case STATUS_GET_BATTERY_HEALTH = 0x05
}

enum HeadphoneManagementCommandId: UInt8 {
    //Namespace: Headphone Management

    case MANAGEMENT_SET_FACTORY_RESET = 0x02
    case MANAGEMENT_GET_OPT_IN_FLAG = 0x03
    case MANAGEMENT_SET_OPT_IN_FLAG = 0x04
}

enum SettingsCommandId: UInt8 {
    //Namespace: Settings

    case SETTINGS_RESET_SETTINGS = 0x03

    case SETTINGS_GET_ANC_BUTTON_CUSTOMIZATION = 0x04
    case SETTINGS_GET_POWER_BUTTON_CUSTOMIZATION = 0x05
    case SETTINGS_SET_ANC_BUTTON_CUSTOMIZATION = 0x06
    case SETTINGS_SET_POWER_BUTTON_CUSTOMIZATION = 0x07
    case SETTINGS_RESET_CUSTOMIZATION = 0x08

    case SETTINGS_GET_DEVICE_NAME = 0x09
    case SETTINGS_SET_DEVICE_NAME = 0x0A
    case SETTINGS_RESET_DEVICE_NAME = 0x0B

    case SETTINGS_GET_WEAR_DETECTION_ACTION = 0x0C
    case SETTINGS_SET_WEAR_DETECTION_ACTION = 0x0D
    case SETTINGS_GET_ANC_MODE = 0x0E
    case SETTINGS_SET_ANC_MODE = 0x0F

    case SETTINGS_GET_PRESET_EQ = 0x10
    case SETTINGS_SET_PRESET_EQ = 0x11

    case SETTINGS_GET_SPATIAL_AUDIO_MODE = 0x12
    case SETTINGS_SET_SPATIAL_AUDIO_MODE = 0x13

    case SETTINGS_GET_HEAD_TRACKING_MODE = 0x14
    case SETTINGS_SET_HEAD_TRACKING_MODE = 0x15

    case SETTINGS_GET_VOICE_GUIDANCE_LANGUAGE = 0x16
    case SETTINGS_SET_VOICE_GUIDANCE_LANGUAGE = 0x17

    case SETTINGS_GET_VOICE_ASSISTANT = 0x18
    case SETTINGS_SET_VOICE_ASSISTANT = 0x19
    case SETTINGS_DISABLE_VOICE_ASSISTANT = 0x1a

    case SETTINGS_VOLUME_GET_MAX_VOLUME = 0x1b
    case SETTINGS_VOLUME_SET_MAX_VOLUME = 0x1c

    case SETTINGS_GET_LOW_POWER_MODE = 0x1d
    case SETTINGS_SET_LOW_POWER_MODE = 0x1e

    case SETTINGS_GET_AUTO_OFF_PERIOD = 0x1f
    case SETTINGS_SET_AUTO_OFF_PERIOD = 0x20

    case SETTINGS_OPTIMIZE_BATTERY = 0x21

    case SETTINGS_GET_CUSTOM_EQ = 0x22
    case SETTINGS_SET_CUSTOM_EQ = 0x23

    case SETTINGS_GET_BALANCE = 0x24
    case SETTINGS_SET_BALANCE = 0x25
}

enum VolumeCommandId: UInt8 {
    //Namespace: Volume

    case VOLUME_GET_VOLUME = 0x03
    case VOLUME_SET_VOLUME = 0x04
}

enum PlaybackCommandId: UInt8 {
    //Namespace: Playback

    case PLAYBACK_PLAY = 0x03
    case PLAYBACK_PAUSE = 0x04
    case PLAYBACK_SKIP_PREV = 0x05
    case PLAYBACK_SKIP_NEXT = 0x06
    case PLAYBACK_GET_PLAYBACK_STATUS = 0x07
    //        PLAYBACK_SHARE = 0x08
}

enum PlaybackMetadataCommandId: UInt8 {
    //Namespace: Playback Metadata
    case PLAYBACK_GET_METADATA = 0x03
}

enum SoundSwapCommandId: UInt8 {
    //Namespace: Sound Swap

    case SOUND_SWAP_GET_PAIRING_DATA = 0x03
    case SOUND_SWAP_INIT_WIFI_SWAP = 0x04
    case SOUND_SWAP_INIT_BLE_SWAP = 0x05
    case SOUND_SWAP_TRIGGER_SWAP = 0x0
}


enum CommandPduType: UInt8 {
    case COMMAND_PDU_OFF = 0x00
    case COMMAND_PDU_ON = 0x01
}

enum BLEOnOffState: UInt8 {
    case STATE_OFF = 0x00
    case STATE_ON = 0x01
}

enum BLEAudioEnhancementMode: UInt8 {
    case MODE_ANC_OFF = 0x00
    case MODE_ANC_ON = 0x01
    case MODE_AMBIENT = 0x02
}

enum BLEPlaybackState: UInt8 {
    case TRANSPORT_STOP = 0x00
    case TRANSPORT_PAUSE = 0x01
    case TRANSPORT_PLAY = 0x02
}

enum BLEAutoOffState: UInt8 {
    case STATE_10_MIN = 0x00
    case STATE_30_MIN = 0x01
    case STATE_1_HOUR = 0x02
    case STATE_2_HOUR = 0x03
    case STATE_3_HOUR = 0x04
}
