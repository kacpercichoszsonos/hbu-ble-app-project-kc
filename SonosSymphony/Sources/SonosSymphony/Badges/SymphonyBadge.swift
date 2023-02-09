//
//  SymphonyBadge.swift
//
//
//  Created by Tri Pham on 12/9/22.
//

import SwiftUI

private extension CGFloat {
    static let textSize: CGFloat = 12
}

/// A badge component that can be used to represent status, presets and notifications.
/// There are two type of SymphonyBadge: text and small. The size of the badge is inferred from
/// its type
public struct SymphonyBadge: View {
    @Environment(\.theme) var theme

    private let color: Color
    private let value: Int?
    private let size: BadgeSize

    private enum BadgeSize: CGFloat {
        case text = 24
        case small = 12
    }

    /// Initialize a badge component with a given text value
    /// - Parameters:
    ///   - value: The value to be displayed within the badge
    ///   - color: The color to be used for the background
    public init(value: Int? = nil, color: Color) {
        self.color = color
        self.value = value
        size = value != nil ? .text : .small
    }

    public var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(color)
            if let text = value {
                Text("\(text)")
                    .font(.system(size: .textSize))
                    .foregroundColor(theme.bgPrimary)
            }
        }
        .frame(width: size.rawValue, height: size.rawValue)
        .apply(if: size == .small) { view  in
            view.overlay(
                Circle()
                    .stroke(theme.primary, lineWidth: 1)
                )
        }
    }
}

struct SymphonyBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SymphonyBadge(color: .green)
            SymphonyBadge(value: 1, color: .green)
        }
        .previewLayout(.sizeThatFits)
    }
}
