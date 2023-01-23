//
//  MeasureSize.swift
//  Passport
//
//  Created by Brandon Wright on 10/10/22.
//

// MARK: Places a clea background on the view with a geometry reader and reads to preference key to measure a view's size at runtime

import Foundation
import SwiftUI


public struct ViewSizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

//public struct MeasureSizeModifier: ViewModifier {
//    public func body(content: Content) -> some View {
//        content.background(GeometryReader { geometry in
//            Color.clear.preference(key: SizePreferenceKey.self,
//                                   value: geometry.size)
//        })
//    }
//}
//
//public extension View {
//    func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
//        self.modifier(MeasureSizeModifier())
//            .onPreferenceChange(SizePreferenceKey.self, perform: action)
//    }
//}




public struct MeasureSizeModifier: ViewModifier {
    
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: ViewSizePreferenceKey.self, value: geometry.size)
        }
    }
    public func body(content: Content) -> some View {
        content
            .background(sizeView)
    }
}

public extension View {
    func measureSize(_ handler: @escaping (CGSize) -> Void) -> some View {
        self
            .modifier(MeasureSizeModifier())
            .onPreferenceChange(ViewSizePreferenceKey.self, perform: { value in
                handler(value)
            })
    }
}
