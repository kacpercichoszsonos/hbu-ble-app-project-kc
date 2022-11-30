//
//  DetailsViewController.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 17/11/2022.
//

import UIKit

private let DetailsCollectionViewCellHeight = 100.0
private let DetailsCollectionViewCellWidthInset = 25.0

class DetailsViewController: ModelledViewController<DetailsViewModel> {

    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "DeviceDetailsCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "DeviceDetailsCollectionViewCell")
        self.title = self.viewModel.device.name
    }

    // MARK: Actions
    @IBAction func didTapConnectBtn() {
        self.viewModel.connectBtnTapped()
    }
}

// MARK: UICollectionViewDataSource
extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.device.data?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceDetailsCollectionViewCell", for: indexPath) as! DeviceDetailsCollectionViewCell
        let data = self.viewModel.device.data?[indexPath.row]
        cell.setupCell(data: data)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - DetailsCollectionViewCellWidthInset), height: DetailsCollectionViewCellHeight)
    }
}
