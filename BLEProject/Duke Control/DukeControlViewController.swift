//
//  DukeControlViewController.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 08/12/2022.
//

import UIKit

class DukeControlViewController: ModelledViewController<DukeControlViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func playPauseBtnTapped(_ sender: Any) {
        //        BleManager.shared.writeData(data: Data[CommandType.COMMAND_TYPE_COMMAND])
    }

    @IBAction func ancSwitchChanged(_ sender: UISwitch) {
        self.viewModel.writeData(setting: CurrentlyUsedSettings.anc, value: sender.isOn)
    }

    @IBAction func headTrackingSwitchChanged(_ sender: UISwitch) {
        self.viewModel.writeData(setting: CurrentlyUsedSettings.headTracking, value: sender.isOn)
    }

    @IBAction func productNameTextFieldEditingDidEnd(_ sender: UITextField) {
        self.viewModel.writeData(setting: CurrentlyUsedSettings.deviceName, value: sender.text)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

enum CurrentlyUsedSettings {
    case anc
    case headTracking
    case deviceName
}
