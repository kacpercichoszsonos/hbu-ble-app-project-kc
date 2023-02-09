//
//  SymphonySectionHeader.swift
//
//
//  Created by Shabina Rayan on 1/18/23.
//

import SwiftUI

fileprivate extension Int {
    static let maxNumLines: Int = 3
}

fileprivate extension CGFloat {
    static let componentSpacing: CGFloat = 8
    static let topSpacing: CGFloat = 16
    static let imageHeight: CGFloat = 48
    static let imageWidth: CGFloat = 48

}

public struct SymphonySectionHeader: View {
    @Environment(\.theme) public var theme: Theme

    @State public var isClicked = false

    private var image: Image?
    private var title: String?
    private var actionText: String?
    private var subtitle: String?
    private var trailingIcon: Image?

    public var body: some View {
        HStack(spacing: .componentSpacing) {
            if let image {
                image
                    .resizable()
                    .frame(width: .imageWidth, height: .imageHeight)
            }

            VStack(alignment: .leading) {
                if let title, !title.isEmpty {
                    Text(title)
                        .font(.title.bold())
                        .foregroundColor(theme.primary)
                }

                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(theme.secondary)
                }
            }
            .lineLimit(Int.maxNumLines)
            .frame(alignment: .leading)

            Spacer()

            if let actionText, !actionText.isEmpty {
                Text(actionText)
                    .frame(alignment: .trailing)
                    .foregroundColor(theme.secondary)
            }

            if let trailingIcon {
                trailingIcon
                    .foregroundColor(theme.secondary)
                    .frame(alignment: .trailing)
            }

        }
        .padding([.horizontal], 0)
        .padding([ .top], .topSpacing)
        .background(Color.clear.edgesIgnoringSafeArea([]))
        .onTapGesture {
            isClicked = true
        }
        .opacity(isClicked ? .pressed : .enabled)
        .sheet(isPresented: $isClicked) {
            Text("🎉 you clicked into the section!")
                .presentationDetents([.medium])
        }
    }

    /// - Parameters:
    ///     - image: Optional image which will be on the leading end of the Section Header
    ///     - title: Optional text which will be the main title of the Section Header
    ///     - subtitle: Optional text which will be the subtitle (below title) of the Section Header
    ///     - actionText: Optional text which will be on the trailing end (before trailingIcon if exists) of the Section Header
    ///     - trailingIcon: Optional image which will be on the trailing end of the Section Header
    ///
    public init(image: Image? = nil,
                title: String? = nil,
                subtitle: String? = nil,
                actionText: String? = nil,
                trailingIcon: Image? = nil) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.actionText = actionText
        self.trailingIcon = trailingIcon
    }
}
