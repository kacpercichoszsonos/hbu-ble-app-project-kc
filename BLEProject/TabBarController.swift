//
//  TabBarController.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 08/12/2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTabBarController()
    }

    func setUpTabBarController() {
        let dukeController = UINavigationController(rootViewController: DukeControlViewController())
        let bleScanner = UINavigationController(rootViewController: BleScannerViewController(viewModel: BleScannerViewModel()))
        self.setViewControllers([dukeController, bleScanner], animated: true)
        guard let items = self.tabBar.items else {
            return
        }

        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.stackedLayoutAppearance.normal.iconColor = .systemBlue
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

            appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        }

        if #available(iOS 13, *) {
            let appearance = UITabBarAppearance()
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .white

            appearance.stackedLayoutAppearance.normal.iconColor = .systemBlue
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

            appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

            self.tabBar.standardAppearance = appearance
        }
        let images = ["headphones", "antenna.radiowaves.left.and.right"]
        for (index, item) in items.enumerated() {
            item.image = UIImage(systemName: images[index])
        }
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let viewController = self.viewControllers?[selectedIndex] as? UINavigationController
        viewController?.popToRootViewController(animated: false)
    }
}
