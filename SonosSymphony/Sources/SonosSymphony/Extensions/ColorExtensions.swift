//
//  ColorExtensions.swift
//  
//
//  Created by Tri Pham on 12/2/22.
//

import SwiftUI

public extension Color {
    /// The standard Sonos background primary color. This is also referred to as bg in Passport Color spec
    static let sonosBackgroundPrimary = Color("bg", bundle: .module)
    /// The standard Sonos background secondary color. This is also referred to as bg1 in Passport Color spec
    static let sonosBackgroundSecondary = Color("bg1", bundle: .module)
    /// The standard Sonos background Tertiary color. This is also referred to as bg2 in Passport Color spec
    static let sonosBackgroundTertiary = Color("bg2", bundle: .module)
    /// The standard Sonos primary color
    static let sonosPrimary = Color("primary", bundle: .module)
    /// The standard Sonos secondary color
    static let sonosSecondary = Color("secondary", bundle: .module)
    /// The standard Sonos accent color
    static let sonosAccent = Color("accent", bundle: .module)
    static let sonosEastCoastAccent = Color("eastCoastAccent", bundle: .module)
}

public extension Color {

    /// Create dynamic Color that automatically adapts to dark and light ColorScheme
    /// - Parameters:
    ///   - light: The color to use in light color scheme
    ///   - dark: The color to use in dark color scheme
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light) })
    }

    /// Create Color from RGB Int values
    /// - Parameters:
    ///   - red: The amount of red in the color. Valid range [0, 255]
    ///   - green: The amount of green in the color. Valid range [0, 255]
    ///   - blue: The amount of blue in the color. Valid range [0, 255]
    init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: Double(red) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0)
    }
}
