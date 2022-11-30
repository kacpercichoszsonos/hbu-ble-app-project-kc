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
    
    func setupCell(data: (key: AdvertisementDataKeys, value: Any)?) {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        switch data?.key {
        case .kCBAdvDataIsConnectable:
            self.titleLabel.text = "Is device connectable?"
            self.descriptionLabel.text = String(data?.value as? Bool ?? false).capitalized
        case .kCBAdvDataLocalName:
            self.titleLabel.text = "Device name:"
            self.descriptionLabel.text = data?.value as? String ?? ""
        case .kCBAdvDataServiceUUIDs:
            self.titleLabel.text = "Service UUID:"
            self.descriptionLabel.text = ((data?.value as? Array<Any>)?.first as? CBUUID)?.uuidString
        case .none:
            self.titleLabel.text = "N/A"
            self.descriptionLabel.text = "N/A"
        }
    }
}
