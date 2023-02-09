//
//  SymphonyButton.swift
//
//
//  Created by Tri Pham on 12/7/22.
//

import SwiftUI

private extension Image {
    func icon() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 24)
    }
}

private extension CGSize {
    func smallerThanMinimumAccessibileSize() -> Bool {
        self.width < .minimumAccessibleSize || self.height < .minimumAccessibleSize
    }
}

private extension CGFloat {
    static let defaultButtonPadding: CGFloat = 16
    static let imageButtonPadding: CGFloat = 10
    static let elementSpacing: CGFloat = 8
}

/// A struct to model SymphonyButton
///
/// SymphonyButton supports many different configurations for labeling. Supported labeling elements include text, badge, image, icon.
/// For text specifically, SymphonyButton provides two main variants of the initializers.
/// The first type takes a raw `StringProtocol` element and display the text without doing localization.
/// The second type takes a Text view label. This variant assumes that the caller will take care of the localization within the provided Text view
public struct SymphonyButton: View {
    @Environment(\.theme) private var theme

    private let label: Text?
    private let badge: SymphonyBadge?
    private let leadingIcon: Image?
    private let trailingIcon: Image?
    private let size: Size
    private let padding: CGFloat
    private let alignment: Alignment
    private let action: () -> Void

    /// An enum to model all sizes supported by ``SymphonyButton``.
    /// The size applies a constraint to the button's height according to Symphony specs
    public enum Size: CaseIterable {
        case small, symphonyDefault, large

        internal var height: CGFloat {
            switch self {
            case .small:
                return 35
            case .symphonyDefault:
                return 44
            case .large:
                return 56
            }
        }
    }

    public enum Alignment: CaseIterable {
        case vertical, horizontal
    }

    /// An enum to model all possible filling styles for ``SymphonyButton``
    public enum FillStyle: CaseIterable {
        /// A button with filled background
        case filled
        /// A button with no background and a bordered
        case outlined
        /// A plain button with no background or outline
        case none

        /// The default filling style for SymphonyButton
        static let standard: SymphonyButton.FillStyle = .filled
    }

    /// Private constructor to consolidate all initialization needs
    private init(_ label: Text? = nil,
                 badge: SymphonyBadge? = nil,
                 leadingIcon: Image? = nil, trailingIcon: Image? = nil,
                 size: Size = .symphonyDefault,
                 padding: CGFloat = .defaultButtonPadding,
                 alignment: Alignment = .horizontal,
                 action: @escaping () -> Void) {
        self.label = label
        self.badge = badge
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.size = size
        self.padding = padding
        self.alignment = alignment
        self.action = action
    }

    private init(text: Text,
                 badge: SymphonyBadge? = nil,
                 leadingIcon: Image? = nil, trailingIcon: Image? = nil,
                 size: Size = .symphonyDefault,
                 padding: CGFloat = .defaultButtonPadding,
                 alignment: Alignment = .horizontal,
                 action: @escaping () -> Void) {
        self.init(text, badge: badge,
                  leadingIcon: leadingIcon, trailingIcon: trailingIcon,
                  size: size, padding: padding, alignment: alignment,
                  action: action)
    }

    public var body: some View {
        Button {
            action()
        } label: {
            if alignment == .horizontal {
                HStack(alignment: .center, spacing: .elementSpacing) {
                    if let badge = badge {
                        badge
                    }
                    if let leadingImage = leadingIcon {
                        leadingImage.icon()
                    }
                    if let text = label {
                        text
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    if let trailingImage = trailingIcon {
                        trailingImage.icon()
                    }
                }
                .padding(.horizontal, padding)
                .textStyle(.body)
                .frame(height: size.height)
                .apply(if: size == .large) {
                    $0.frame(maxWidth: .infinity)
                }
            } else {
                VStack(alignment: .leading, spacing: .elementSpacing) {
                    if let badge = badge {
                        badge
                    }
                    if let leadingImage = leadingIcon {
                        leadingImage.icon()
                    }
                    if let text = label {
                        text
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    if let trailingImage = trailingIcon {
                        trailingImage.icon()
                    }
                }
                .padding(.horizontal, padding)
                .textStyle(.body)
                .frame(height: size.height)
                .apply(if: size == .large) {
                    $0.frame(maxWidth: .infinity)
                }
            }
        }
    }
}

public extension SymphonyButton {
    /// Initialize a SymphonyButton with only text label
    init<Label>(_ label: Label, size: Size = .symphonyDefault,
                action: @escaping () -> Void) where Label: StringProtocol {
        self.init(Text(label), size: size, action: action)
    }

    /// Initialize a button with only image.
    ///
    /// This can be used for both icon-based and image-based button. The different between the two type is more  of a UX distinction.
    /// From the SymphonyButton perspective, the image will be styled the same way.
    init(_ image: Image, size: Size = .symphonyDefault, action: @escaping () -> Void) {
        self.init(leadingIcon: image, size: size, padding: .imageButtonPadding, action: action)
    }

    /// Initialize a SymphonyButton with a text label and images.
    /// - Parameters:
    ///     - leadingIcon: The icon/image to be displayed on the leading edge of thebutton
    ///     - trailingIcon:  The icon/image to be displayed on the trailing edge of the button
    ///     - size: The size of this button. If this is not specified, a default size will be used
    ///     - action: The action to be performed by pressing this button
    init<Label>(_ label: Label,
                leadingIcon: Image, trailingIcon: Image,
                size: Size = .symphonyDefault,
                action: @escaping () -> Void) where Label: StringProtocol {
        self.init(Text(label),
                  leadingIcon: leadingIcon, trailingIcon: trailingIcon,
                  size: size, action: action)
    }

    /// Initialize a SymphonyButton with a text label and a leading icon.
    ///  - Parameters:
    ///     - leadingIcon: The icon/image to be displayed on the leading edge of thebutton
    ///     - size: The size of this button. If this is not specified, a default size will be used
    ///     - action: The action to be performed by pressing this button
    init<Label>(_ label: Label,
                leadingIcon: Image,
                size: Size = .symphonyDefault,
                alignment: Alignment = .horizontal,
                action: @escaping () -> Void) where Label: StringProtocol {
        self.init(Text(label),
                  leadingIcon: leadingIcon,
                  size: size,
                  alignment: alignment,
                  action: action)
    }

    /// Initialize a SymphonyButton with a text label and a trailing icon.
    ///  - Parameters:
    ///     - trailingIcon: The icon/image to be displayed on the leading edge of thebutton
    ///     - size: The size of this button. If this is not specified, a default size will be used
    ///     - action: The action to be performed by pressing this button
    init<Label>(_ label: Label,
                trailingIcon: Image,
                size: Size = .symphonyDefault,
                action: @escaping () -> Void) where Label: StringProtocol {
        self.init(Text(label),
                  trailingIcon: trailingIcon,
                  size: size, action: action)
    }

    /// Initialize a SymphonyButton with a ``SymphonyBadge`` and a text label
    /// - Parameters:
    ///     - badge: ``SymphonyBadge`` to be displayed within this button.
    ///     The SymphonyButton assumed the badge to have the right size according to UX spec so no further processing or styling will be applied to the provided ``SymphonyBadge``
    ///     - label: The label that describe what this button does.
    ///     - size: The size of this button. If this is not specified, a default size will be used
    ///     - action: The action to be performed by pressing this button
    init<Label>(_ badge: SymphonyBadge,
                label: Label,
                size: Size = .symphonyDefault,
                action: @escaping () -> Void) where Label: StringProtocol {
        self.init(Text(label), badge: badge, size: size, action: action)
    }
}

// MARK: Localizable versions

public extension SymphonyButton {
    /// Initialize a SymphonyButton with only text label
    /// - Parameters:
    ///   - localizedText: a Text view that handles its own localization
    ///   - size: The size of this button. If this is not specified, a default size will be used
    ///   - action: The action to be performed by pressing this button
    init(_ localizedText: Text, size: Size = .symphonyDefault,
         action: @escaping () -> Void) {
        self.init(text: localizedText, size: size, action: action)
    }

    /// Initialize a SymphonyButton with a text label from LocalizedStringKey and images.
    /// - Parameters:
    ///     - localizedText: a Text view that handles its own localization
    ///     - leadingIcon: The icon/image to be displayed on the leading edge of thebutton
    ///     - trailingIcon:  The icon/image to be displayed on the trailing edge of the button
    ///     - size: The size of this button. If this is not specified, a default size will be used
    ///     - action: The action to be performed by pressing this button
    init(_ localizedText: Text,
         leadingIcon: Image, trailingIcon: Image,
         size: Size = .symphonyDefault,
         action: @escaping () -> Void) {
        self.init(text: localizedText,
                  leadingIcon: leadingIcon, trailingIcon: trailingIcon,
                  size: size, action: action)
    }

    /// Initialize a SymphonyButton with a text label from LocalizedStringKey and a leading icon.
    ///  - Parameters:
    ///     - localizedText: a Text view that handles its own localization
    ///     - leadingIcon: The icon/image to be displayed on the leading edge of thebutton
    ///     - size: The size of this button. If this is not specified, a default size will be used
    ///     - action: The action to be performed by pressing this button
    init(_ localizedText: Text,
         leadingIcon: Image,
         size: Size = .symphonyDefault,
         action: @escaping () -> Void) {
        self.init(text: localizedText,
                  leadingIcon: leadingIcon,
                  size: size, action: action)
    }

    /// Initialize a SymphonyButton with a text label from LocalizedStringKey and a trailing icon.
    ///  - Parameters:
    ///     - localizedText: a Text view that handles its own localization
    ///     - trailingIcon: The icon/image to be displayed on the leading edge of thebutton
    ///     - size: The size of this button. If this is not specified, a default size will be used
    ///     - action: The action to be performed by pressing this button
    init(_ localizedText: Text,
         trailingIcon: Image,
         size: Size = .symphonyDefault,
         action: @escaping () -> Void) {
        self.init(text: localizedText,
                  trailingIcon: trailingIcon,
                  size: size, action: action)
    }

    /// Initialize a SymphonyButton with a ``SymphonyBadge`` and a text label
    /// - Parameters:
    ///     - badge: ``SymphonyBadge`` to be displayed within this button.
    ///     The SymphonyButton assumed the badge to have the right size according to UX spec so no further processing or styling will be applied to the provided ``SymphonyBadge``
    ///     - localizedText: a Text view that handles its own localization
    ///     - size: The size of this button. If this is not specified, a default size will be used
    ///     - action: The action to be performed by pressing this button
    init(_ badge: SymphonyBadge,
         _ localizedText: Text,
         size: Size = .symphonyDefault,
         action: @escaping () -> Void) {
        self.init(text: localizedText, badge: badge, size: size, action: action)
    }
}

struct SymphonyButton_Previews: PreviewProvider {
    static var previews: some View {
        SymphonyButton(Image("Plus", bundle: .module)) {  /*Intentionally left blank*/  }.buttonStyle(.symphonyPrimary)
    }
}
