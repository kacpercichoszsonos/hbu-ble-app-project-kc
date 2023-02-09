//
//  ViewExtensions.swift
//
//
//  Created by Tri Pham on 12/9/22.
//

import SwiftUI

public extension View {
    /// Applies a transformation to the receiving view if a given condition is true
    /// - Parameters:
    ///   - condition: The condition to check
    ///   - transform: The transformation that should be applied to the receiving view if the condition is true
    /// - Returns: The transformed view if the condition is true or the original view otherwise
    @ViewBuilder
    func apply<Content: View>(if condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
