//
//  ProgressBarCircular.swift
//  Passport
//
//  Created by Brandon Wright on 7/11/22.
//

import SwiftUI

public struct ProgressBarCircular: View {

    public let progress: Double
    public var lineWidth: Double
    
    public init (progress: Double = 0, lineWidth: Double = 30) {
        self.progress = progress
        self.lineWidth = lineWidth
    }
    
    
    public var body: some View {
        ZStack {
            
            // Could use the new Gauge in iOS 16 ??
            Circle()
                .fill(.background).opacity(0.1)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

struct ProgressBarCircular_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarCircular(progress: 0.1, lineWidth: 30)
            .accentColor(.purple)
    }
}
