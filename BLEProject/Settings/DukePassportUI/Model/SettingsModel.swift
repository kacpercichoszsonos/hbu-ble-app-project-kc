//
//  SettingsModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 08/02/2023.
//

import Foundation

// MARK: - Settings
struct Settings: Codable {
    let sections: [Section]
}

// MARK: - Section
struct Section: Codable {
    let header: String
    let subsections: [Subsection]
}

// MARK: - Subsection
struct Subsection: Codable {
    let title, actionIcon: String
    let subtitle: String?
    let yellowRow: Bool?
    let actionText, leadingIcon: String?
}
