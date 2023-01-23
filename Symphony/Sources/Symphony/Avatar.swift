//
//  AvatarView.swift
//  Passport
//
//  Created by Brandon Wright on 4/21/22.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct Avatar: View {

    public var size: CGFloat
    public var radius: CGFloat
    public var imagePath: String?
    public var text: String

    public var fillColor: Color
    public var badgeColor: Color
    public var textColor: Color
    
    public var showBadge: Bool = true
    public var badgeSize: CGFloat = 12.0

    
    public init(
        size: CGFloat = CGFloat(32.0),
        radius: CGFloat = 100,
        imagePath: String? = nil,
        text: String = "A",
        fillColor: Color = .black,
        badgeColor: Color = .white,
        textColor: Color = .black,
        showBadge: Bool = true,
        badgeSize: CGFloat = 12.0
    ){
        self.size = size
        self.radius = radius
        self.imagePath = imagePath
        self.text = text
        self.fillColor = fillColor
        self.badgeColor = badgeColor
        self.textColor = textColor
        self.showBadge = showBadge
        self.badgeSize = badgeSize
    }
    
    
    public var body: some View {
        
        ZStack{
            
            
            // Image
            if (imagePath != nil){
                CustomImage(image: imagePath ?? "", radius: radius)
                    .frame(width: size, height: size, alignment: .center).cornerRadius(radius)
    
            }else{
                Rectangle()
                    .fill(fillColor)
                    .frame(width: size, height: size, alignment: .center)
                    .cornerRadius(radius)
                Text(text.uppercased())
                    .foregroundColor(textColor)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            
            if(showBadge){
                Badge(size: badgeSize, showText: false, strokeColor: textColor, fillColor: badgeColor, textColor: textColor)
                    .offset(x: size / 2.66, y: -(size / 2.66) )
            }
                
        }
        
    }
}

struct Avatar_Previews: PreviewProvider {

    static var previews: some View {
        Avatar(size: 24, fillColor: .red)
            .background(.black)
            .foregroundColor(.white)
            .accentColor(.green)
            .preferredColorScheme(.dark)
    }
}
