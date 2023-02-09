//
//  SymphonyUISliderRepresentable.swift
//  

import Foundation
import SwiftUI

fileprivate extension Float {
    // the step size for incrementing the slider
    static let stepSize: Float = 1
}

fileprivate extension CGFloat {
    // the diameter of the thumb of the slider
    static let thumbDiameter: CGFloat = 16
}

/// A wrapper that allows our custom UIKit slider to be used in SwiftUI
struct SymphonyUISliderRepresentable: UIViewRepresentable {
    @Environment(\.isEnabled) private var isEnabled: Bool

    @Binding var value: Float
    var range: ClosedRange<Float>
    var minTrackColor: UIColor
    var maxTrackColor: UIColor

    // A closure that will run when a slider is dragged (but not when it is tapped)
    var onSliderDragged: (() -> Void)?

    // These bindings get set to true when the corresponding button is pressed in the delta slider and they stay false otherwise
    @Binding var minButtonPressed: Bool
    @Binding var maxButtonPressed: Bool

    // MARK: - Initializers

    /// An initializer for when we don't need the min/max button bindings. This is used by the range slider as range sliders do not need min and max buttons.
    /// - Parameters:
    ///   - value: A binding for the current value of the slider
    ///   - range: The range of the slider, where the lower bound is the minimum value of the slider and the upper bound is the maximum value of the slider
    ///   - minTrackColor: The track color to the left of the thumb (aka the min side)
    ///   - maxTrackColor: The track color to the right of the thumb (aka the max side)
    ///   - onSliderDragged: A closure that runs when a slider is dragged. Pass in a closure that you'd like to run when a slider is dragged
    init(value: Binding<Float>,
         range: ClosedRange<Float>,
         minTrackColor: UIColor,
         maxTrackColor: UIColor,
         onSliderDragged: @escaping () -> Void = { /* do nothing by default */ }) {
        self.init(
            value: value,
            range: range,
            minTrackColor: minTrackColor,
            maxTrackColor: maxTrackColor,
            minButtonPressed: Binding.constant(false),
            maxButtonPressed: Binding.constant(false),
            onSliderDragged: onSliderDragged)
    }

    /// An initializer that allows setting the min and max button bindings, and accepts only one track color. This is used by delta sliders which have min and max buttons.
    /// - Parameters:
    ///   - value: A binding for the current value of the slider
    ///   - range: The range of the slider, where the lower bound is the minimum value of the slider and the upper bound is the maximum value of the slider
    ///   - trackColor: The track color to be set on the whole track. This gives a fully filled appearance
    ///   - minButtonPressed: A binding that gets set to true when the minimum button is pressed and stays false otherwise
    ///   - maxButtonPressed: A binding that gets set to true when the maximum button is pressed and stays false otherwise
    init(value: Binding<Float>,
         range: ClosedRange<Float>,
         trackColor: UIColor,
         minButtonPressed: Binding<Bool>,
         maxButtonPressed: Binding<Bool>) {
        self.init(
            value: value,
            range: range,
            minTrackColor: trackColor,
            maxTrackColor: trackColor,
            minButtonPressed: minButtonPressed,
            maxButtonPressed: maxButtonPressed)
    }

    /// An initializer that allows setting all of the properties
    /// - Parameters:
    ///   - value: A binding for the current value of the slider
    ///   - range: The range of the slider, where the lower bound is the minimum value of the slider and the upper bound is the maximum value of the slider
    ///   - minTrackColor: The track color to the left of the thumb (aka the min side)
    ///   - maxTrackColor: The track color to the right of the thumb (aka the max side)
    ///   - minButtonPressed: A binding that gets set to true when the minimum button is pressed in the delta slider and stays false otherwise
    ///   - maxButtonPressed: A binding that gets set to true when the maximum button is pressed in the delta slider and stays false otherwise
    ///   - onSliderDragged: A closure that runs when a slider is dragged. Pass in a closure that you'd like to run when a slider is dragged
    private init(value: Binding<Float>,
                 range: ClosedRange<Float>,
                 minTrackColor: UIColor,
                 maxTrackColor: UIColor,
                 minButtonPressed: Binding<Bool>,
                 maxButtonPressed: Binding<Bool>,
                 onSliderDragged: @escaping () -> Void = { /* do nothing by default */ }) {
        self._value = value
        self.range = range
        self.minTrackColor = minTrackColor
        self.maxTrackColor = maxTrackColor

        self._minButtonPressed = minButtonPressed
        self._maxButtonPressed = maxButtonPressed

        self.onSliderDragged = onSliderDragged
    }

    // MARK: - UIViewRepresentable functions

    /// Creates the slider and initializes it
    func makeUIView(context: Context) -> SymphonyUISlider {
        let slider = SymphonyUISlider(frame: .zero)
        slider.onSliderDragged = onSliderDragged
        updateSlider(slider)

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        return slider
    }

    /// Updates the state of the slider with new information from SwiftUI. This this method is triggered when the bindings change in value.
    func updateUIView(_ slider: SymphonyUISlider, context: Context) {
        updateSlider(slider)

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        // if minButtonPressed or maxButtonPressed was set to true, its corresponding button was pressed and we should increment as appropriate
        if minButtonPressed {
            DispatchQueue.main.async {
                slider.decrementValue()
                minButtonPressed = false
            }
        }

        if maxButtonPressed {
            DispatchQueue.main.async {
                slider.incrementValue()
                maxButtonPressed = false
            }
        }
    }

    /// Updates the slider to the desired value, colors, min and max value, and enabled state
    /// - Parameter slider: the slider that needs to be updated
    func updateSlider(_ slider: SymphonyUISlider) {
        slider.value = value.rounded()

        slider.tintColor = minTrackColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor

        slider.maximumValue = range.upperBound
        slider.minimumValue = range.lowerBound
        slider.isContinuous = true

        slider.isEnabled = isEnabled
    }

    /// Creates the coordinator that is used to communicate between SwiftUI and the slider
    func makeCoordinator() -> SymphonyUISliderRepresentable.Coordinator {
        Coordinator(value: $value)
    }

    /// The coordinator class that communicates between SwiftUI and the slider. At the moment it only communicates changes to the value.
    final class Coordinator: NSObject {
        var value: Binding<Float>

        init(value: Binding<Float>) {
            self.value = value
        }

        @objc func valueChanged(_ sender: SymphonyUISlider) {
            self.value.wrappedValue = sender.value.rounded()
        }
    }

    // MARK: - UISlider Implementation

    /// The custom Symphony UISlider
    class SymphonyUISlider: UISlider, UIGestureRecognizerDelegate {

        var onSliderDragged: (() -> Void)?

        private var oldValue: Float = -1
        private lazy var haptics = UIImpactFeedbackGenerator(style: .light)

        override init(frame: CGRect) {
            super.init(frame: frame)
            addTarget(self, action: #selector(onValueChanged), for: .valueChanged)

            let tap = UITapGestureRecognizer(target: self, action: #selector(trackTapped(sender:)))
            tap.delegate = self
            addGestureRecognizer(tap)

            setThumbImage(normalThumbImage, for: .normal)
        }

        /// A basic thumb image that has a defined thumb diameter
        var normalThumbImage: UIImage {
            let rect = CGRect(x: 0, y: 0, width: .thumbDiameter, height: .thumbDiameter)

            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

            tintColor.setFill()
            UIBezierPath(ovalIn: rect).fill()

            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            return image
        }

        /// Listens to .valueChanged and snaps the slider to whole numbers. Also triggers haptics when the value is new.
        @objc func onValueChanged() {
            value = value.rounded()

            if value != oldValue {
                // only trigger haptics if the value has changed
                haptics.impactOccurred()

                // run the onSliderDragged closure
                if let onSliderDragged {
                    onSliderDragged()
                }

                oldValue = value
            }
        }

        /// Listens for changes in the tint color and updates the thumb image to match
        override func tintColorDidChange() {
            super.tintColorDidChange()
            setThumbImage(normalThumbImage, for: .normal)

        }

        /// Assigns a new value to the slider and triggers haptics if it is a new value.
        /// - Parameter newValue: The value to be set on the slider
        private func setValue(to newValue: Float) {
            guard newValue >= minimumValue, newValue <= maximumValue else { return }

            // check that value is changing before triggering haptics and firing a valueChanged event
            if newValue != value {
                value = newValue.rounded()
                oldValue = value
                haptics.impactOccurred()
                sendActions(for: .valueChanged)
            }
        }

        /// Increments the slider by the step size amount, making sure not to go above maximumValue
        func incrementValue() {
            setValue(to: min(maximumValue, (value + .stepSize).rounded()))
        }

        /// Decrements the slider by the step size amount, making sure not to go below minimumValue
        func decrementValue() {
            setValue(to: max(minimumValue, (value - .stepSize).rounded()))
        }

        /// A listener that gets called when the slider is tapped. If the user tapped on the right of the thumb, the volume increments. If the user tapped on the left of the thumn, the volume decrements.
        /// - Parameter sender: The gesture recognizer
        @objc func trackTapped (sender: UITapGestureRecognizer) {
            let point = sender.location(in: self)
            let track = trackRect(forBounds: bounds)
            let thumb = thumbRect(forBounds: bounds, trackRect: track, value: value)

            if point.x > thumb.maxX {
                incrementValue()
            } else if point.x < thumb.minX {
                decrementValue()
            } else {
                haptics.impactOccurred()
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
