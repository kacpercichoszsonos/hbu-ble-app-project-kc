//
//  CustomToggle.swift
//  Passport
//
//  Created by Brandon Wright on 7/30/22.
//

import SwiftUI

public struct CheckToggleStyle: ToggleStyle {
    public init () {
        
    }
    public func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


public struct ColoredToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color
    var thumbColorOn: Color
    var thumbColorOff: Color

    public init (onColor: Color, offColor: Color, thumbColorOn: Color, thumbColorOff: Color) {
        self.onColor = onColor
        self.offColor = offColor
        self.thumbColorOn = thumbColorOn
        self.thumbColorOff = thumbColorOff
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label // The text (or view) portion of the Toggle
            Spacer()
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 50, height: 29)
                .overlay(
                    Circle()
                        .fill(configuration.isOn ? thumbColorOn : thumbColorOff)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(1.5)
                        .offset(x: configuration.isOn ? 10 : -10))
                .animation(Animation.easeInOut(duration: 0.2), value: configuration.isOn)
                .onTapGesture { configuration.isOn.toggle() }
        }
        .padding(.horizontal)
    }
}

//struct CustomToggle_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomToggle()
//    }
//}
