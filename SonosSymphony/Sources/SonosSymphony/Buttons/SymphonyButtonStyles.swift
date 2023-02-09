//
//  SymphonyButtonStyle.swift
//
//
//  Created by Tri Pham on 12/7/22.
//

import SwiftUI

// MARK: SymphonyButton style

/// A protocol to describe Symphony-specific ButtonStyle
///
/// In theory you can implement your own SymphonyButtonStyle by conforming to this protocol
/// the benefit of doing this is that you will get the default coloring strategy from Symphony spec for free
public protocol SymphonyButtonStyle: ButtonStyle {
    typealias FillStyle = SymphonyButton.FillStyle

    /// The ``Theme`` to use for this SymphonyButton style
    ///
    /// This is typically implemented by using `@Environment(\.theme)`
    var theme: Theme { get }

    /// Bool value that indicate whether or not this button is enabled.
    ///
    /// This is typically implemented by extracting isEnabled from `@Environment(\.isEnabled)`
    var isEnabled: Bool { get }

    /// Color used for text/label within the button
    var foregroundColor: Color { get }

    /// Color used for background of the button
    var backgroundColor: Color { get }

    /// Color used for border if the button style is `SymphonyButtonStyle.outlined`
    var outlineColor: Color { get }

    /// The style to apply to apply to this button
    var fillStyle: FillStyle { get }
}

private extension SymphonyButtonStyle {
    /// Shared coloring strategy used by all ``SymphonyButtonStyle``
    @ViewBuilder
    func makeBodyInternal(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .clipShape(Capsule())
            .apply(if: fillStyle == .outlined) {
                $0.overlay(Capsule()
                    .stroke(outlineColor, lineWidth: 1))
            }
            // we want to flatten the hierachy and apply opacity on top of the entire view
            .compositingGroup()
            .opacity(opacity(isPressed: configuration.isPressed))
            .frame(minWidth: 44, minHeight: 44)
    }

    func opacity(isPressed: Bool) -> Double {
        if !isEnabled {
            return .disabled
        }

        return isPressed ? .pressed : .enabled
    }
}

// MARK: SymphonyPrimaryButtonStyle

/// Primary Symphony Button style
///
/// This button style applies the look and feel of Symphony Primary Button to your Button. You can apply this style by using `.buttonStyle<S>(_:ButtonStyle)`
/// modifier on any SymphonyButton. To make things convenient and simple, we provided two syntactic sugars to create this style
///
/// ```swift
///     SymphonyButton("Primary") {
///          // perform some action
///     }
///     .buttonStyle(.symphonyPrimary)
/// ```
///
/// or to specify a FillStyle
/// ```
///     SymphonyButton("Primary") {
///          // perform some action
///     }
///     .buttonStyle(.symphonyPrimary(fill: .filled)
/// ```
public struct SymphonyPrimaryButtonStyle: SymphonyButtonStyle {
    @Environment(\.theme) public var theme: Theme
    @Environment(\.isEnabled) public var isEnabled: Bool

    public let fillStyle: SymphonyButton.FillStyle
    public var foregroundColor: Color {
        switch fillStyle {
        case .filled:
            return theme.bgPrimary
        case .outlined, .none:
            return theme.primary
        }
    }

    public var backgroundColor: Color {
        switch fillStyle {
        case .filled:
            return theme.primary
        case .outlined, .none:
            return Color.clear
        }
    }

    public var outlineColor: Color {
        theme.primary
    }

    public init(fillStyle: SymphonyButton.FillStyle = .filled) {
        self.fillStyle = fillStyle
    }

    public func makeBody(configuration: Configuration) -> some View {
        makeBodyInternal(configuration: configuration)
    }
}

public extension ButtonStyle where Self == SymphonyPrimaryButtonStyle {
    /// SymphonyPrimaryButtonStyle with default filling style
    static var symphonyPrimary: SymphonyPrimaryButtonStyle {
        .symphonyPrimary(fill: .standard)
    }

    /// Create a ``SymphonyPrimaryButtonStyle`` with custom filling style
    /// - Parameter fill: The FillStyle to apply
    /// - Returns:a ``SymphonyPrimaryButtonStyle`` with the given FillStyle
    static func symphonyPrimary(fill: SymphonyButton.FillStyle) -> SymphonyPrimaryButtonStyle {
        SymphonyPrimaryButtonStyle(fillStyle: fill)
    }
}

// MARK: SymphonySecondaryButtonStyle

/// Secondary Symphony Button style
///
/// This button style applies the look and feel of Symphony Secondary Button to your Button. You can apply this style by using `.buttonStyle<S>(_:ButtonStyle)`
/// modifier on any SymphonyButton. To make things convenient and simple, we provided two syntactic sugars to create this style
///
/// ```swift
///     SymphonyButton("Secondary") {
///          // perform some action
///     }
///     .buttonStyle(.symphonySecondary)
/// ```
///
/// or to specify a FillStyle
/// ```
///     SymphonyButton("Secondary") {
///          // perform some action
///     }
///     .buttonStyle(.symphonySecondary(fill: .filled)
/// ```
public struct SymphonySecondaryButtonStyle: SymphonyButtonStyle {
    @Environment(\.theme) public var theme: Theme
    @Environment(\.isEnabled) public var isEnabled: Bool

    public let fillStyle: SymphonyButton.FillStyle
    public var foregroundColor: Color {
        switch fillStyle {
        case .filled, .outlined:
            return theme.primary
        case .none:
            return theme.secondary
        }
    }

    public var backgroundColor: Color {
        switch fillStyle {
        case .filled:
            return theme.bgSecondary
        case .outlined, .none:
            return Color.clear
        }
    }

    public var outlineColor: Color {
        theme.secondary
    }

    public init(fillStyle: SymphonyButton.FillStyle = .filled) {
        self.fillStyle = fillStyle
    }

    public func makeBody(configuration: Configuration) -> some View {
        makeBodyInternal(configuration: configuration)
    }
}

public extension ButtonStyle where Self == SymphonySecondaryButtonStyle {
    /// SymphonySecondaryButtonStyle with default filling style
    static var symphonySecondary: SymphonySecondaryButtonStyle {
        .symphonySecondary(fill: .standard)
    }

    /// Create a ``SymphonySecondaryButtonStyle`` with custom filling style
    /// - Parameter fill: The FillStyle to apply
    /// - Returns:a ``SymphonySecondaryButtonStyle`` with the given FillStyle
    static func symphonySecondary(fill: SymphonyButton.FillStyle) -> SymphonySecondaryButtonStyle {
        SymphonySecondaryButtonStyle(fillStyle: fill)
    }
}
