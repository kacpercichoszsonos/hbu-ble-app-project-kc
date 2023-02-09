//
//  SwiftUIView.swift
//  
//
//  Created by Tri Pham on 1/4/23.
//

import SwiftUI

fileprivate extension TimeInterval {
    static let switchChangeDuration: TimeInterval = 0.2 // sec
}

fileprivate extension CGFloat {
    static let switchWidth: CGFloat = 56
    static let switchHeight: CGFloat = 32
    static let borderWidth: CGFloat = 2
    static let thumbSize: CGFloat = 16
    static let switchPadding: CGFloat = 8
    static let thumbOnOffset: CGFloat = 24
    static let tappableHeight: CGFloat = 44
    static let cornerRadius: CGFloat = .switchHeight / 2
}

fileprivate extension View {
    func trackShape() -> some View {
        self.frame(width: .switchWidth, height: .switchHeight)
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
    }
}

public struct SymphonySwitch: View {
    // MARK: Internal
    @Binding public var isOn: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.theme) private var theme

    @State private var haptics = UIImpactFeedbackGenerator(style: .light)

    private var thumbOffset: CGFloat {
        isOn ? (.thumbOnOffset + .switchPadding) : .switchPadding
    }

    private func toggle() {
        if isEnabled {
            withAnimation(.easeOut(duration: .switchChangeDuration)) {
                haptics.impactOccurred()
                isOn.toggle()
            }
        }
    }

    // MARK: Public APIs

    /// Create a Symphony Switch
    /// - Parameter isOn: The binding that will be controlled by this Switch
    public init(isOn: Binding<Bool>) {
        self._isOn = isOn
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            if isOn {
                RoundedRectangle(cornerRadius: .cornerRadius)
                    .fill(theme.primary)
                    .trackShape()
                    .transition(.opacity)
            }
            RoundedRectangle(cornerRadius: .cornerRadius)
                .strokeBorder(theme.primary, lineWidth: .borderWidth)
                .trackShape()
            Circle()
                .fill(isOn ? theme.bgPrimary : theme.primary)
                .frame(width: .thumbSize, height: .thumbSize)
                .offset(x: thumbOffset, y: 0)
        }
        .compositingGroup()
        .opacity(isEnabled ? .enabled : .disabled)
        .frame(height: .tappableHeight)
        .onTapGesture {
            toggle()
        }
    }
}

struct SymphonySwitch_Previews: PreviewProvider {
    @Environment(\.theme) var theme
    static var previews: some View {
        VStack {
            SymphonySwitch(isOn: .constant(true))
            SymphonySwitch(isOn: .constant(false))
        }
        .frame(width: 100, height: 100)
        .background(Theme.standard.bgSecondary)
    }
}
