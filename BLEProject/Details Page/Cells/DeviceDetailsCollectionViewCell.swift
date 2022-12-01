//
//  DeviceDetailsCollectionViewCell.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 18/11/2022.
//

import UIKit
import CoreBluetooth

class DeviceDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setupCell(bleData: BleData?) {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        switch bleData?.key {
        case .kCBAdvDataIsConnectable:
            self.titleLabel.text = "Is device connectable?"
            self.descriptionLabel.text = String(bleData?.value as? Bool ?? false).capitalized
        case .kCBAdvDataLocalName:
            self.titleLabel.text = "Device name:"
            self.descriptionLabel.text = bleData?.value as? String ?? ""
        case .kCBAdvDataServiceUUIDs:
            self.titleLabel.text = "Service UUID:"
            self.descriptionLabel.text = ((bleData?.value as? Array<Any>)?.first as? CBUUID)?.uuidString
        case .characteristicBatteryLevel:
            self.titleLabel.text = "Battery Level:"
            self.descriptionLabel.text = "\((bleData?.value as? String ?? "Unknown")) %"
        case .characteristicManufacturerName:
            self.titleLabel.text = "Manufacturer Name:"
            self.descriptionLabel.text = bleData?.value as? String ?? ""
        case .characteristicModelName:
            self.titleLabel.text = "Model Name: "
            self.descriptionLabel.text = bleData?.value as? String ?? ""
        case .none:
            // In case for some reason we will get some data without the known key, let's populate cell with N/A
            self.titleLabel.text = "N/A"
            self.descriptionLabel.text = "N/A"
        }
    }
}
