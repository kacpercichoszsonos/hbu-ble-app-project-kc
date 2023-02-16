//
//  SymphonyCard.swift
//

import SwiftUI

// MARK: - Internal
private extension CGFloat {
    static let cardCornerRadius: CGFloat = 32
    static let cardDragThreshold: CGFloat = 75
    static let cardPadding: CGFloat = 24

    static let handleCornerRadius: CGFloat = 100
    static let handleHeight: CGFloat = 4
    static let handleVerticalPadding: CGFloat = 10
    static let handleWidth: CGFloat = 44
}

// A ViewModifier containing the Symphony Card constants
private struct SymphonyCardConstantsViewModifier: ViewModifier {
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding([.horizontal, .bottom], .cardPadding)
            .background(theme.bgSecondary)
            .clipShape(RoundedRectangle(cornerRadius: .cardCornerRadius, style: .continuous))
    }
}

// A ViewModifier containing the Symphony Card Handle constants
private struct SymphonyCardHandleConstantsViewModifier: ViewModifier {
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        HStack {
            content
                .frame(width: .handleWidth, height: .handleHeight)
                .cornerRadius(.handleCornerRadius)
                .foregroundColor(theme.bgTertiary)
                .padding(.vertical, .handleVerticalPadding)
        }
        .frame(maxWidth: .infinity)
    }
}

private extension View {
    @ViewBuilder
    func symphonyCardModifiers() -> some View {
        self.modifier(SymphonyCardConstantsViewModifier())
    }

    @ViewBuilder
    func symphonyCardHandleModifiers() -> some View {
        self.modifier(SymphonyCardHandleConstantsViewModifier())
    }
}

// The main Symphony Card ViewModifier
private struct SymphonyCardViewModifier: ViewModifier {
    @Environment(\.theme) private var theme
    @GestureState private var draggedOffset: CGFloat = 0
    let dragAction: (() -> Void)?

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            dragAction != nil ? handle() : nil
            Spacer()
            content
            Spacer()
        }
        .symphonyCardModifiers()
        .offset(y: draggedOffset)
    }

    private func handle() -> some View {
        Rectangle()
            .symphonyCardHandleModifiers()
            .contentShape(Rectangle())
            .gesture(dragGesture())
    }

    private func dragGesture() -> some Gesture {
        DragGesture(coordinateSpace: .global)
            .updating($draggedOffset) { value, state, _ in
                if value.translation.height > 0 {
                    state = value.translation.height
                }
            }
            .onEnded { value in
                if value.translation.height >= .cardDragThreshold,
                   let dragAction {
                    dragAction()
                }
            }
    }
}

// MARK: - Public
public extension View {
    /// Embed the view in a Symphony Card.
    /// - Parameter withDragAction: An optional closure. When a closure is provided, it enables the card to be dragged down,
    /// and it executes when the card is dragged passed the threshold.
    /// - Returns: A new view with the content embedded in a Symphony Card.
    @ViewBuilder
    func symphonyCard(withDragAction: (() -> Void)? = nil) -> some View {
        self.modifier(SymphonyCardViewModifier(dragAction: withDragAction))
    }
}

// MARK: - Preview
struct SymphonyCard_Previews: PreviewProvider {
    struct PreviewCardView: View {
        @State private var showingAlert = false

        var body: some View {
            Text("Test View")
                .symphonyCard(withDragAction: {showingAlert = true})
                .alert("Dragged", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {showingAlert = false}
                }
        }
    }

    static var previews: some View {
        PreviewCardView()
    }
}
