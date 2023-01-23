//
//  SwiftUIView.swift
//  
//
//  Created by Brandon Wright on 9/27/22.
//

import SwiftUI
import DynamicColor

fileprivate var buttonAnimation = Animation.interactiveSpring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.5)
fileprivate var buttonScalePressed = 0.9


public struct PrimaryButton: ButtonStyle {
    @EnvironmentObject var theme: Theme

    public var background: Color?
    
    public init(background: Color? = nil){
        self.background = background
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.headline.weight(.semibold))
            .padding(16)
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .background((self.background != nil) ? self.background : theme.primary)
            .foregroundColor(Color(DynamicColor(theme.primary).shaded()))
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? buttonScalePressed : 1)
            .animation(buttonAnimation, value: configuration.isPressed)
    }
}

public struct SecondaryButton: ButtonStyle {
    @EnvironmentObject var theme: Theme
    
    public var background: Color?
    
    public init(background: Color? = nil){
        self.background = background
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.headline.weight(.semibold))
            .padding(16)
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .background((self.background != nil) ? self.background : theme.bg2)
            .foregroundColor(theme.primary)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? buttonScalePressed : 1)
            .animation(buttonAnimation, value: configuration.isPressed)
    }
}



public struct SmallSecondaryButton: ButtonStyle {
    @EnvironmentObject var theme: Theme
    
    public var background: Color?
    
    public init(background: Color? = nil){
        self.background = background
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.headline.weight(.semibold))
            .padding(8)
            .padding(.leading, 4)
            .padding(.trailing, 4)
            .background((self.background != nil) ? self.background : theme.bg2)
            .foregroundColor(theme.primary)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? buttonScalePressed : 1)
            .animation(buttonAnimation, value: configuration.isPressed)
    }
}



public struct IconButtonSecondary: ButtonStyle {
    @EnvironmentObject var theme: Theme

    
    public var background: Color?
    
    public init(background: Color? = nil){
        self.background = background
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.headline.weight(.semibold))
            .padding(16)
            .background((self.background != nil) ? self.background : theme.bg2)
            .foregroundColor(theme.primary)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? buttonScalePressed : 1)
            .animation(buttonAnimation, value: configuration.isPressed)
    }
}




struct ButtonStyles_Previews: PreviewProvider {
    
    static var theme = Theme.example
    
    static var previews: some View {
        VStack{
            Button {
            } label: {
                Text("Primary Button")
            }.buttonStyle(PrimaryButton())
            
            Button {
            } label: {
                Image(systemName: "wifi")
            }.buttonStyle(IconButtonSecondary())
            
            Button {
            } label: {
                Text("Secondary Button")
            }.buttonStyle(SecondaryButton())
            
            Button {
            } label: {
                Text("Bordered Prominent")
                        .frame(maxWidth: .infinity)
            }.buttonStyle(PrimaryButton())
            
            
            Button {
            } label: {
                Text("Bordered Prominent")
                        .frame(maxWidth: .infinity)
            }.buttonStyle(PrimaryButton(background: .red))

        }
        .preferredColorScheme(.dark)
        .environmentObject(theme)
    }
}
