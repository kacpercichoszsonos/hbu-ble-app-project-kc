//
//  SymphonyRangeSlider.swift
//  
//

import SwiftUI

fileprivate extension ClosedRange<Float> {
    // the default range for a volume slider
    static let defaultRange: ClosedRange<Float> = 0...100
}

/// A view that models the Symphony Range Slider. Range sliders should not have negative values and fill from left to right.
public struct SymphonyRangeSlider: View {
    @Environment(\.theme) private var theme
    @Environment(\.isEnabled) private var isEnabled: Bool

    @Binding private var value: Float
    @Binding private var isMuted: Bool

    private var range: ClosedRange<Float>

    // MARK: - Public APIs

    /// Initialize a range slider with a default range (0 to 100) with a mute status. This is meant to be used for volume sliders.
    /// - Parameters:
    ///   - value: A binding for the current value of the slider
    ///   - isMuted: A binding for the mute status of the slider. When isMuted is true the slider is still adjustable but greyed out.
    public init(value: Binding<Float>, isMuted: Binding<Bool>) {
        self.init(value: value, in: .defaultRange, isMuted: isMuted)
    }

    /// Initialize a range slider with a range, and no ability to mute. This slider can still be disabled as normal but cannot be muted.
    /// - Parameters:
    ///   - value: A binding for the current value of the slider
    ///   - range: The range of the slider, where the lower bound is the minimum value of the slider and the upper bound is the maximum value of the slider
    public init(value: Binding<Float>, in range: ClosedRange<Float>) {
        self.init(value: value, in: range, isMuted: Binding.constant(false))
    }

    /// Initialize a range slider with a value, a range and mute status
    /// - Parameters:
    ///   - value: A binding for the current value of the slider
    ///   - range: The range of the slider, where the lower bound is the minimum value of the slider and the upper bound is the maximum value of the slider
    ///   - isMuted: A binding for the mute status of the slider. When isMuted is true the slider is still adjustable but greyed out.
    public init(value: Binding<Float>, in range: ClosedRange<Float>, isMuted: Binding<Bool>) {
        self._value = value
        self._isMuted = isMuted
        self.range = range
    }

    public var body: some View {
        SymphonyUISliderRepresentable(
            value: $value,
            range: range,
            minTrackColor: UIColor(theme.primary),
            maxTrackColor: UIColor(theme.primary.opacity(.disabled)),
            onSliderDragged: {
                // if a slider is muted when it is dragged, unmute it
                if isMuted {
                    isMuted = false
                }
            })
            .opacity((isMuted || !isEnabled ) ? .disabled : .enabled)
    }
}

// MARK: - Preview
struct SymphonyRangeSlider_Previews: PreviewProvider {
    @State static var value: Float = 50
    @State static var isMuted = false

    static var previews: some View {
        SymphonyRangeSlider(value: $value, isMuted: $isMuted)
    }
}
