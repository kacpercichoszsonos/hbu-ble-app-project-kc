//
//  SymphonyPageHeader.swift
//  
//
//  Created by Kenny Cabral Jr on 1/17/23.
//

import SwiftUI

fileprivate extension Int {
    static let maxNumLines: Int = 3
}

fileprivate extension CGFloat {
    static let horizontalSpacing: CGFloat = 16
    static let verticalSpacing: CGFloat = 0
    static let eyebrowTextIconSpacing: CGFloat = 4
}

public struct SymphonyPageHeader: View {
    @Environment(\.theme) public var theme: Theme

    private var image: Image?
    private var title: String?
    private var subTitle: String?
    private var eyebrowText: String?
    private var eyebrowIcon: Image?
    private var icon: Image?
    private var performButtonAction: (() -> Void)?

    /// HStack that contains the icon for the eyebrow along with the eyebrow text
    var eyebrow: some View {
        HStack(spacing: .eyebrowTextIconSpacing) {
            if let eyebrowIcon {
                eyebrowIcon
                    .renderingMode(.template)
            }
            if let eyebrowText,
               !eyebrowText.isEmpty {
                Text(eyebrowText)
                    .font(.subheadline)
                    .lineLimit(.maxNumLines)
            }
        }
    }

    /// VStack that contains the eyebrow, title, and subtitle
    var textStack: some View {
        VStack(alignment: .leading, spacing: .verticalSpacing) {
            eyebrow
                .foregroundColor(theme.secondary)
            if let title,
               !title.isEmpty {
                    Text(title)
                        .font(.largeTitle)
                        .bold()
            }
            if let subTitle,
               !subTitle.isEmpty {
                Text(subTitle)
                    .font(.subheadline)
                    .foregroundColor(theme.secondary)
            }
        }
        .lineLimit(.maxNumLines)
    }

    /// Body that organizes the components outined above
    public var body: some View {
        HStack(alignment: .center, spacing: .horizontalSpacing) {
            if let image {
                image
            }
            textStack
            Spacer()
            if let icon {
                Button {
                    if let performButtonAction {
                        performButtonAction()
                    }
                } label: {
                    icon
                        .renderingMode(.template)
                        .foregroundColor(theme.primary)
                }
                .buttonStyle(TrailingButtonStyle())
            }
        }
    }
    /// - Parameters:
    ///     - image: An optional image that will be placed toward the leading edge of the Page Header
    ///     - title: Optional text that will be used for the main title
    ///     - subTitle: Optional text that will be placed below the title
    ///     - eyebrowText: Optional text that will be placed above the Title
    ///     - eyebrowIcon: Icon placed towards the beginning of the eyebrow text
    ///     - icon: Optional image used for the trailing button
    ///     - buttonAction: Optional function to get called when the trailing button is tapped
    public init(image: Image? = nil,
                title: String? = nil,
                titleIcon: Image? = nil,
                subTitle: String? = nil,
                eyebrowText: String? = nil,
                eyebrowIcon: Image? = nil,
                icon: Image? = nil,
                buttonAction: (() -> Void)? = nil) {

        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.eyebrowText = eyebrowText
        self.eyebrowIcon = eyebrowIcon
        self.icon = icon
        self.performButtonAction = buttonAction
    }
}
/// Button style for the optional trailing button
private struct TrailingButtonStyle: ButtonStyle {
    @Environment(\.theme) public var theme: Theme
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(theme.primary)
            .opacity(configuration.isPressed ? .pressed : .enabled)
    }
}

struct SymphonyPageHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Multiple previews that are designed to stress test the Page Header in various ways
            let eyebrowPlaceholderText = "Eyebrow Placeholder Text"
            let titlePlaceholderText = "Test Title"
            let subtitlePlaceholderText = "Test Subtitle"
            ScrollView(.vertical) {
                SymphonyPageHeader(
                           title: "Super duper ultra mega wow this is a really long Title",
                           subTitle: "Supercalifragilisticexpialidociously why would you make this such a crazy long Subtitle",
                           eyebrowText: "Supercalifragilisticexpialidociously long and super convolutedly and crazy Placeholder Text",
                           icon: Image("Settings", bundle: .module)
                )
                SymphonyPageHeader(
                           title: titlePlaceholderText,
                           subTitle: subtitlePlaceholderText,
                           eyebrowText: eyebrowPlaceholderText,
                           icon: Image("Settings", bundle: .module)
                )
                SymphonyPageHeader(
                           title: titlePlaceholderText,
                           eyebrowText: eyebrowPlaceholderText,
                           icon: Image("Settings", bundle: .module)
                )
                SymphonyPageHeader(
                           title: titlePlaceholderText,
                           subTitle: subtitlePlaceholderText,
                           icon: Image("Settings", bundle: .module)
                )
                SymphonyPageHeader(
                           title: titlePlaceholderText,
                           icon: Image("Settings", bundle: .module)
                )
                SymphonyPageHeader(
                           title: titlePlaceholderText
                )
            }
        }
    }
}
