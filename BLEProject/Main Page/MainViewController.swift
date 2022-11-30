//
//  MainViewController.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 14/11/2022.
//

import UIKit

private let MainMenuCollectionViewCellHeight = 50.0
private let MainMenuCollectionViewCellWidthInset = 25.0

class MainViewController: ModelledViewController<MainViewModel> {
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.update?(.landing)
        self.collectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "MainCollectionViewCell")
    }

    override func updateView(_ type: MainViewModel.UpdateType) {
        switch type {
        case .landing:
            self.loadingView.isHidden = true
        case .loading:
            self.collectionView.isHidden = true
            self.loadingView.isHidden = false
        case .reload:
            self.collectionView.isHidden = false
            self.loadingView.isHidden = true
            self.collectionView.reloadData()
        }
    }

    // MARK: Actions
    @IBAction func sonosDeviceSwitch(_ sender: UISwitch) {
        self.viewModel.setSonosOnlySearchBool(_value: sender.isOn)
    }

    @IBAction func didTapOnStartScanningBtn() {
        self.viewModel.startScanning()
    }
}

// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.devices?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        cell.setupCell(peripheralName: self.viewModel.devices?[indexPath.row].name)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let device = self.viewModel.devices?[indexPath.row] {
            let viewModel = DetailsViewModel(device: device)
            let viewController = DetailsViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - MainMenuCollectionViewCellWidthInset), height: MainMenuCollectionViewCellHeight)
    }
}
