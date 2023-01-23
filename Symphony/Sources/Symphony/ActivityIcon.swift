//
//  SwiftUIView.swift
//  
//
//  Created by Brandon Wright on 10/17/22.
//

import SwiftUI

public struct ActivityIcon: View {
    
    public var barCount: Int
    public var gap: CGFloat
    public var size: CGFloat
    public var speed: CGFloat
    
    @State private var moving = false
    
    public init(barCount: Int = 4, gap: CGFloat = 4, size: CGFloat = 24, speed: CGFloat = 0.2) {
        self.barCount = barCount
        self.gap = gap
        self.size = size
        self.speed = speed
    }
    
    public var body: some View {
        
        HStack(spacing: self.gap){
            ForEach((0...self.barCount - 1), id: \.self) { index in
                Rectangle().fill(.foreground).cornerRadius(100)
                    .frame(height: moving ? 1 : size)
                    .animation(.easeInOut(duration: Double.random(in: speed...speed * 2) ).repeatForever(autoreverses: true), value: moving)
            }
        }
        .frame(width: self.size, height: self.size, alignment: .bottom)
        .onAppear{
            moving.toggle()
        }
        .onDisappear{
            moving = false
        }
    }
}


struct ActivityIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24){
            ActivityIcon(barCount: 4, size: 44)
            ActivityIcon(barCount: 8, gap: 2, size: 124, speed: 0.4)
            ActivityIcon(barCount: 16, gap: 4, size: 124, speed: 0.6)
            ActivityIcon(barCount: 12, gap: 4, size: 124, speed: 1.3)
//            ActivityIcon(barCount: 32, gap: 2, size: 124, speed: 0.2)
            ActivityIcon(barCount: 32, gap: 4, size: 244, speed: 0.2)
        }.foregroundColor(.black)
    }
}
