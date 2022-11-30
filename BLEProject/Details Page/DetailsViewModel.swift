//
//  DetailsViewModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 17/11/2022.
//

import Foundation

class DetailsViewModel: ViewModel, ViewModelProtocol {
    var device: BleDeviceModel

    var update: ((DetailsViewModel.UpdateType) -> Void)?
    enum UpdateType {
    }

    init(device: BleDeviceModel) {
        self.device = device
        super.init()
    }

    func connectBtnTapped() {
        BleManager.shared.connectDevice(peripheral: self.device.peripheral)
    }
}
