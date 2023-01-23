//
//  Badge.swift
//  Passport
//
//  Created by Brandon Wright on 4/21/22.
//

import SwiftUI

public struct Badge: View {

    public var size: CGFloat
    public var showText: Bool
    public var text: String = "1"
    
    public var strokeColor: Color = .white
    public var fillColor: Color = .black
    public var textColor: Color = .white

    
    public init(size: CGFloat = 16, showText: Bool = false, text: String = "1", strokeColor: Color = .white, fillColor: Color = .black, textColor: Color = .white ) {
        self.size = size
        self.showText = showText
        self.text = text
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.textColor = textColor
    }
    
    
    public var body: some View {
        ZStack{
            Circle()
                .strokeBorder(strokeColor, lineWidth: 2)
                .background(Circle().fill(fillColor))
                .frame(width: size, height: size)
            if (showText){
                Text(text)
                    .foregroundColor(textColor)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }

    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge(size: 16, showText: true, text: "2")
    }
}
