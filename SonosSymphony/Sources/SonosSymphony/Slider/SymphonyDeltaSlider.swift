//
//  SymphonyDeltaSlider.swift
//
//

import SwiftUI

/// A view that models the Symphony Delta Slider. Delta sliders have a tick in the middle (at the 0 point) and have negative and positive values.
public struct SymphonyDeltaSlider: View {
    @Environment(\.theme) private var theme
    @Environment(\.isEnabled) private var isEnabled: Bool

    @Binding private var value: Float
    private var range: ClosedRange<Float>

    private var tickView: some View {
        Rectangle().frame(width: 2, height: 12, alignment: .center)
    }

    // MARK: - Min/Max Buttons

    // the images for the min and max buttons
    private var minimumValueImage: Image?
    private var maximumValueImage: Image?

    // the bindings which report button presses to the UIKit layer
    @State private var minButtonPressed: Bool = false
    @State private var maxButtonPressed: Bool = false

    // the minimum button, which appears on the left of the slider
    // if minimumValueImage is nil, .map returns an EmptyView
    // if it's not nil we build the SymphonyButton with that image
    private var minButton: some View {
        minimumValueImage.map { image in
            SymphonyButton(image, size: .small) {
                minButtonPressed = true
            }
            .buttonStyle(.symphonyPrimary(fill: .none))
        }
    }

    // the maximum button, which appears on the right of the slider
    // if maximumValueImage is nil, .map returns an EmptyView
    // if it's not nil we build the SymphonyButton with that image
    private var maxButton: some View {
        maximumValueImage.map { image in
            SymphonyButton(image, size: .small) {
                maxButtonPressed = true
            }
            .buttonStyle(.symphonyPrimary(fill: .none))
        }
    }

    // MARK: - Public APIs

    /// Initialize a delta slider with just value and range. This delta slider will have no min/max buttons.
    /// - Parameters:
    ///   - value: A binding for the current value of the slider
    ///   - range: The range of the slider, where the lower bound is the minimum value of the slider and the upper bound is the maximum value of the slider
    public init(value: Binding<Float>, in range: ClosedRange<Float>) {
        self.init(value: value, in: range, minimumValueImage: nil, maximumValueImage: nil)
    }

    /// Initialize a delta slider with value, range, and min and/or max buttons.
    /// - Parameters:
    ///   - value: A binding for the current value of the slider
    ///   - range: The range of the slider, where the lower bound is the minimum value of the slider and the upper bound is the maximum value of the slider
    ///   - minimumValueImage: An optional image to be displayed on the minimum side of the slider. Pass in a nil if you don't want a button on the left side.
    ///   - maximumValueImage: An optional image to be displayed on the maximum side of the slider. Pass in a nil if you don't want a button on the right side.
    public init(value: Binding<Float>, in range: ClosedRange<Float>, minimumValueImage: Image?, maximumValueImage: Image?) {
        self._value = value
        self.range = range
        self.minimumValueImage = minimumValueImage
        self.maximumValueImage = maximumValueImage
    }

    public var body: some View {
        HStack(alignment: .center) {
            minButton
            ZStack(alignment: .center) {
                tickView
                SymphonyUISliderRepresentable(
                    value: $value,
                    range: range,
                    trackColor: UIColor(theme.primary),
                    minButtonPressed: $minButtonPressed,
                    maxButtonPressed: $maxButtonPressed)
            }
            .compositingGroup()
            .opacity(isEnabled ? .enabled : .disabled)
            maxButton
        }
    }
}

struct SymphonyDeltaSlider_Previews: PreviewProvider {
    @State static var value: Float = 0

    static var previews: some View {
        SymphonyDeltaSlider(
            value: $value,
            in: -10...10,
            minimumValueImage: Image("Minus", bundle: .module),
            maximumValueImage: Image("Plus", bundle: .module))
    }
}
