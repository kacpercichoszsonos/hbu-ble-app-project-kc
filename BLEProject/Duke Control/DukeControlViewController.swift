//
//  DukeControlViewController.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 08/12/2022.
//

import UIKit

class DukeControlViewController: ModelledViewController<DukeControlViewModel> {
    @IBOutlet weak var ancSwitch: UISwitch!
    @IBOutlet weak var headTrackingSwitch: UISwitch!
    @IBOutlet weak var productNameTextfield: UITextField!
    @IBOutlet weak var dukeConnectedView: UIView!
    @IBOutlet weak var dukeNotConnectedView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func updateView(_ type: DukeControlViewModel.UpdateType) {
        switch type {
        case .dukeNotConnected:
            self.dukeNotConnectedView.isHidden = false
            self.dukeConnectedView.isHidden = true
        case .reloadDukeValues:
            self.productNameTextfield.placeholder = self.viewModel.dukeModel?.deviceName
            if let ancMode = self.viewModel.dukeModel?.ancMode {
                self.ancSwitch.isOn = ancMode
            }
            if let headTrackingMode = self.viewModel.dukeModel?.headTrackingMode {
                self.headTrackingSwitch.isOn = headTrackingMode
            }
            self.dukeNotConnectedView.isHidden = true
            self.dukeConnectedView.isHidden = false
        }
    }

    @IBAction func productNameTextFieldDidEndOnExit(_ sender: UITextField) {
        self.viewModel.writeData(setting: CurrentlyUsedSettings.deviceName, value: sender.text)
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
