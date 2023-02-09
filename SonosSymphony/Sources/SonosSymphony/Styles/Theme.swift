//
//  Theme.swift
//  
//
//  Created by Tri Pham on 12/2/22.
//

import SwiftUI

// MARK: - Theme

/// A model preseting a theme. A theme in the context of Symphony components is a collection of colors.
/// Colors within a theme is assumed to support both __dark and light appearence__.
///
/// **1. Differences between ColorScheme and Theme**
///
/// A theme should not be confused with ColorScheme which controls the dark/light appearance of views in SwiftUI.
/// A theme for our purpose is simply a collection of colors which can be used to color UI elements. Colors within a theme are assumed to have already taken into account
/// different ColorSchemes (dark vs. light). If you want to use the same color for both dark and light mode, simply provide a non-dynamic color.
///
/// **2. Overriding theme**
///
/// It is possible to provide a different theme for a specific View component instead of inheriting the theme from the parent view.
/// This can be done by providing the theme via `.theme(_:Theme)` modifier on the view
///
///     struct MyView: View {
///         private let myCustomTheme = Theme.someCustomTheme
///         var body: some View {
///             SymphonyButton("My colorful button")
///                 .theme(myCustomTheme)
///         }
///     }
///
public struct Theme: Identifiable, Equatable {
    /// The id of this theme
    public var id = UUID()

    /// The name of this theme
    public var name: String

    /// The primary background color
    public var bgPrimary: Color

    /// The secondary background color
    public var bgSecondary: Color

    /// The tertiary background color
    public var bgTertiary: Color

    /// Used for title and heading text, and primary elements
    public var primary: Color

    /// Used for body text, secondary elements
    public var secondary: Color

    /// Accent color is used to draw attention and highlight important information
    public var accent: Color

    /// Initialize a ColorTheme structure with required components
    /// - Parameters:
    ///   - name: The name of this theme
    ///   - bgPrimary: The primary background color
    ///   - bgSecondary: The secondary background color
    ///   - bgTertiary: The tertiary background color
    ///   - primary: Used for title and heading text, and primary elements
    ///   - secondary: Used for body text, secondary elements
    ///   - accent: Accent color is used to draw attention and highlight important information
    public init(name: String,
                bgPrimary: Color, bgSecondary: Color, bgTertiary: Color,
                primary: Color, secondary: Color, accent: Color) {
        self.name = name
        self.bgPrimary = bgPrimary
        self.bgSecondary = bgSecondary
        self.bgTertiary = bgTertiary
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
    }
}

public extension Theme {
    /// The standard Sonos theme that comes with Sonos's standard colors
    static let standard = Theme(name: "standard",
                                bgPrimary: .sonosBackgroundPrimary,
                                bgSecondary: .sonosBackgroundSecondary,
                                bgTertiary: .sonosBackgroundTertiary,
                                primary: .sonosPrimary,
                                secondary: .sonosSecondary,
                                accent: .sonosAccent)
}

// MARK: - EnvironmentValues

private struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: Theme = .standard
}

public extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

public extension View {
    /// Set color theme for the current view. This can be used to override inherited parent's color theme.
    /// - Parameter theme: The new color theme to be used in this view and its children views
    /// - Returns: A new view with the updated color theme
    func theme(_ theme: Theme) -> some View {
        environment(\.theme, theme)
    }
}
