//
//  SymphonyPlayProgress.swift
//
//
//  Created by Tri Pham on 12/10/22.
//

import SwiftUI

fileprivate extension Double {
    var sanitized: Double {
        // progress should be within [0.0, 1.0] range (inclusive)
        let progressRange: ClosedRange<Double> = 0.0...1.0
        if progressRange.contains(self) {
            return self
        } else {
            return self < progressRange.lowerBound
                ? progressRange.lowerBound
                : progressRange.upperBound
        }
    }

    static let inactiveOpacity: Double = 0.1
    static let tapTransitionDuration: Double = 0.3
}

fileprivate extension CGFloat {
    static let buttonSize: CGFloat = 44
    static let iconSize: CGFloat = 24
    static let progressLineWidth: CGFloat = 4
}

/// A view that models Play Progress button
public struct SymphonyPlayProgress: View {
    // MARK: Internals

    @Environment(\.theme) private var theme: Theme
    @Binding private var isPlaying: Bool

    private let isActive: Bool
    private let progress: Double?
    private let resumable: Bool

    private struct PlayProgressButtonStyle: ButtonStyle {
        @Environment(\.isEnabled) var isEnabled: Bool

        func opacity(isPressed: Bool) -> Double {
            if !isEnabled {
                return .disabled
            }

            return isPressed ? .pressed : .enabled
        }

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .clipShape(Circle())
                .frame(width: .buttonSize, height: .buttonSize)
                .opacity(opacity(isPressed: configuration.isPressed))
        }
    }

    private struct CircularProgress: Shape {
        let progress: Double

        func path(in rect: CGRect) -> Path {
            let rotationAdjustment = Angle.degrees(90)
            let modifiedStart = .zero - rotationAdjustment
            let modifiedEnd = Angle(degrees: 360 * progress) - rotationAdjustment

            var path = Path()
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                        radius: rect.width / 2,
                        startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: false)

            return path
        }
    }

    private var activeBody: some View {
        ZStack {
            Circle()
                .fill(theme.bgPrimary)
                .environment(\.colorScheme, .dark)
            if isPlaying {
                Image("Play", bundle: .module)
                    .transition(.scale)
                    .blendMode(.destinationOut)
            } else {
                Image(resumable ? "Pause" : "Stop", bundle: .module)
                    .transition(.scale)
                    .blendMode(.destinationOut)
            }
        }
        .compositingGroup()
    }

    private func inactiveTransportIcon(name: String) -> some View {
        Image(name, bundle: .module)
            .renderingMode(.template)
            .foregroundColor(theme.bgPrimary)
            .transition(.scale)
    }

    private var inactiveBody: some View {
        ZStack {
            Circle()
                .fill(theme.primary.opacity(.inactiveOpacity))
                .environment(\.colorScheme, .light)
            if isPlaying {
                inactiveTransportIcon(name: "Play")
            } else {
                inactiveTransportIcon(name: resumable ? "Pause" : "Stop")
            }
            if let progress {
                CircularProgress(progress: progress)
                    .stroke(theme.bgPrimary, lineWidth: .progressLineWidth)
            }
        }
    }

    private func toggleIsPlaying() {
        withAnimation(.easeInOut(duration: .tapTransitionDuration)) {
            isPlaying.toggle()
        }
    }

    // MARK: Public APIs

    /// Create a SymphonyPlayProgress
    /// - Parameters:
    ///   - isPlaying: a binding that controls the playing state of this play progress.
    ///   Tapping the play progress will toggle this binding.
    ///   - isActive: a boolean that indicates the active state of this play progress.
    ///   - progress: the progress in closed range [0.0, 1.0].
    ///   Value outside of this range will be clamped to the closest end of the allowable range.
    ///   If no progress value is specified, the play progress will not display any progress indicator when it is in inactive state.
    ///   - resumable: if true the play progress will display a pause icon when not in playing state, otherwise a stop icon will be used.
    public init(isPlaying: Binding<Bool>, isActive: Bool,
                progress: Double? = nil, resumable: Bool = true) {
        self._isPlaying = isPlaying
        self.isActive = isActive
        self.progress = progress?.sanitized
        self.resumable = resumable
    }

    public var body: some View {
        Button {
            toggleIsPlaying()
        } label: {
            if isActive {
                activeBody
            } else {
                inactiveBody
            }
        }
        .environment(\.colorScheme, .dark)
        .buttonStyle(PlayProgressButtonStyle())
    }
}
