/*
 TextStyles.swift
 Created by Brandon Wright on 9/28/22.
 Defines the text styles for symphony view modifiers
 */

import SwiftUI


// MARK: Main View Title
// Used to title a view. There should only every be one main title per view

public struct ViewTitle: ViewModifier {
    public init(){} // Accessible outside out package
    public func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.semibold))
    }
}

// MARK: Section Title
// Section title style is used for the title in the SectionHeader component.

public struct SectionTitle: ViewModifier {
    public init(){}
    public func body(content: Content) -> some View {
        content
            .font(.title2.weight(.semibold))
    }
}

// MARK: Item Title
// Item title style is for the title text in List and Grid item components.

public struct ItemTitle: ViewModifier {
    public init(){}
    public func body(content: Content) -> some View {
        content
            .font(.title3.weight(.semibold))
    }
}

// MARK: Body Text
// Normal text in a view.

public struct BodyText: ViewModifier {
    public init(){}
    public func body(content: Content) -> some View {
        content
            .font(.body.weight(.regular))
    }
}


public struct SubTitle: ViewModifier {
    @EnvironmentObject var theme: Theme
    public init(){}
    public func body(content: Content) -> some View {
        content
            .font(.subheadline.weight(.regular)).foregroundColor(theme.secondary)
    }
}



// Modifiers to apply the right foreground color to our type styles below. Provies access to our enironment theme object

//public struct PrimaryTextColor: ViewModifier {
//    @EnvironmentObject var theme: Theme
//    public init(){}
//    public func body(content: Content) -> some View {
//        content
//            .foregroundColor(theme.primary)
//    }
//}
//
//public struct SecondaryTextColor: ViewModifier {
//    @EnvironmentObject var theme: Theme
//    public init(){}
//    public func body(content: Content) -> some View {
//        content
//            .foregroundColor(theme.secondary)
//    }
//}
//
//public struct AccentTextColor: ViewModifier {
//    @EnvironmentObject var theme: Theme
//    public init(){}
//    public func body(content: Content) -> some View {
//        content
//            .foregroundColor(theme.accent)
//    }
//}


// Extend Text to allow easy application of text view modifiers: Usage example: .textStyle(SectionTitle())
//public extension Text {
//    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
//        ModifiedContent(content: self, modifier: style)
//    }
//}

// We can extend view to make it easier to use ie: .viewTitle() instead of .modifier(ViewTitle()) ??
public extension View {
    func viewTitle() -> some View {
        modifier(ViewTitle())
    }
    func sectionTitle() -> some View {
        modifier(SectionTitle())
    }
    func itemTitle() -> some View {
        modifier(ItemTitle())
    }
    func bodyText() -> some View {
        modifier(BodyText())
    }
    func SubTitleText() -> some View {
        modifier(SubTitle())
    }
}
