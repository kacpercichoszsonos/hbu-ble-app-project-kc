//
//  Styles.swift
//  
//
//  Created by Tri Pham on 12/5/22.
//

import Foundation
import SwiftUI

/// An enum to model Symphony specific text styling. Styles in this context include font, font weight, foreground color, etc.
/// See [Symphony Typography](https://www.figma.com/file/1qNDzeDfU7astjLof9AuXJ/Symphony-iOS-%F0%9F%8D%8E?node-id=469%3A12535&t=orhv9M6rmxRCE3bK-0)
public enum SymphonyTextStyle: String, CaseIterable {
    case largeTitle
    case title
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption
    case caption2
}

// MARK: Styles

struct LargeTitleStyle: ViewModifier {
    @Environment(\.theme) private var currentTheme

    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(currentTheme.primary)
    }
}

struct TitleStyle: ViewModifier {
    @Environment(\.theme) private var currentTheme

    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.medium)
            .foregroundColor(currentTheme.primary)
    }
}

struct Title2Style: ViewModifier {
    @Environment(\.theme) private var currentTheme

    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.medium)
            .foregroundColor(currentTheme.primary)
    }
}

struct Title3Style: ViewModifier {
    @Environment(\.theme) private var currentTheme

    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.medium)
            .foregroundColor(currentTheme.primary)
    }
}

struct HeadlineStyle: ViewModifier {
    @Environment(\.theme) private var currentTheme

    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(currentTheme.primary)
    }
}

struct BodyStyle: ViewModifier {
    @Environment(\.theme) private var currentTheme

    func body(content: Content) -> some View {
        content
            .font(.body)
    }
}

struct CalloutStyle: ViewModifier {
    @Environment(\.theme) private var currentTheme

    func body(content: Content) -> some View {
        content
            .font(.callout)
            .foregroundColor(currentTheme.secondary)
    }
}

struct SubheadStyle: ViewModifier {
    @Environment(\.theme) private var currentTheme

    func body(content: Content) -> some View {
        content
            .font(.callout)
            .foregroundColor(currentTheme.secondary)
    }
}

struct FootnoteStyle: ViewModifier {
    @Environment(\.theme) private var currentTheme

    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(currentTheme.secondary)
    }
}

struct CaptionStyle: ViewModifier {
    @Environment(\.theme) private var currentTheme

    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(currentTheme.secondary)
    }
}

struct Caption2Style: ViewModifier {
    @Environment(\.theme) private var currentTheme

    func body(content: Content) -> some View {
        content
            .font(.caption2)
            .foregroundColor(currentTheme.secondary)
    }
}

// An extension on View rather than Text, so you can use
// this for other view like button labels, textfields, labels etc
public extension View {

    /// Set the text style to be used for this view
    /// - Parameter style: The ``SymphonyTextStyle`` to be applied to this view.
    /// - Returns: A new view with ``SymphonyTextStyle`` applied
    @ViewBuilder
    func textStyle(_ style: SymphonyTextStyle) -> some View {
        switch style {
        case .largeTitle:
            self.modifier(LargeTitleStyle())
        case .title:
            self.modifier(TitleStyle())
        case .title2:
            self.modifier(Title2Style())
        case .title3:
            self.modifier(Title3Style())
        case .headline:
            self.modifier(HeadlineStyle())
        case .callout:
            self.modifier(CalloutStyle())
        case .subheadline:
            self.modifier(SubheadStyle())
        case .footnote:
            self.modifier(FootnoteStyle())
        case .caption:
            self.modifier(CaptionStyle())
        case .caption2:
            self.modifier(Caption2Style())
        default:
             self.modifier(BodyStyle())
        }
    }
}
