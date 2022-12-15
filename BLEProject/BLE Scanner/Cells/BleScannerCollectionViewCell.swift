//
//  MainCollectionViewCell.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 15/11/2022.
//

import UIKit

class BleScannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    func setupCell(peripheralName: String?) {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        guard let peripheralName else {
            self.titleLabel.text = "Unknown device"
            return
        }

        self.titleLabel.text = peripheralName
    }
}
