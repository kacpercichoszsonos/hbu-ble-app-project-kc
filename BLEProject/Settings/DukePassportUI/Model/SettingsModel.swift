//
//  SettingsModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 08/02/2023.
//

import Foundation

// MARK: - Welcome
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
    let sheetSection: [SheetSection]?
    let subtitle: String?
    let yellowRow: Bool?
    let actionText, leadingIcon: String?
}

// MARK: - SheetSection
struct SheetSection: Codable {
    let listViewTitle: String
    let checked: Bool?
}
