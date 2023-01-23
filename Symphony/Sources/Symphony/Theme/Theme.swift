//
//  Theme.swift
//  Passport
//
//  Created by Brandon Wright on 4/9/22.
//

import UIKit
import Foundation
import DynamicColor
import SwiftUI


public class Theme: ObservableObject, Identifiable{
    public var id = UUID()
    public var name: String
    
//    public var palette: Array<DynamicColor>
    public var backgroundPalette: Array<DynamicColor>
    public var primaryPalette: Array<DynamicColor>
    public var accentPalette: Array<DynamicColor>
    
//    static let example = Theme(name: "Default Symphony Theme", colors: [
//        UIColor(hexString: "#000000"),
//        UIColor(hexString: "#333333"),
//        UIColor(hexString: "#444444"),
//        UIColor(hexString: "#d8d8d8"),
//        UIColor(hexString: "#ffffff"),
//        UIColor(hexString: "#cdedf6"),
//    ])
    
    
    public static let example = Theme(background: .black)
    
    
    public init (name: String? = nil, background: Color, primary: Color? = nil, accent: Color? = nil)
    {
        self.name = name ?? "My Theme"
        self.backgroundPalette = Theme.createBackgroundPalette(color: background)
        self.primaryPalette = Theme.createPrimaryPalette(color: primary ?? background)
        self.accentPalette = Theme.createAccentPalette(color: accent ?? Color(DynamicColor(background).saturated(amount: 1.0).complemented()))
    }
    
}


private extension Theme {
    static func createBackgroundPalette(color: Color) -> Array<DynamicColor> {
        
        let dark = DynamicColor(color).shaded(amount: 0.92)
        let light = DynamicColor(color).tinted(amount: 0.92)
        
        // Generate a gradient palette with 8 stops from darkest to lightest
        return [dark, light].gradient.colorPalette(amount: 8, inColorSpace: .hsb)
    }
    
    
    static func createPrimaryPalette(color: Color) -> Array<DynamicColor> {
        
        let dark = DynamicColor(color).shaded(amount: 0.9)
        let light = DynamicColor(color).tinted(amount: 0.9)
        
        // Generate a gradient palette with 8 stops from darkest to lightest
        return [dark, light].gradient.colorPalette(amount: 2, inColorSpace: .hsb)
    }
    
    static func createAccentPalette(color: Color) -> Array<DynamicColor> {
                
        let dark = DynamicColor(color).shaded(amount: 0.95)
        let light = DynamicColor(color).tinted(amount: 0.95)
        
        // Generate a gradient palette with 8 stops from darkest to lightest
        return [dark, light].gradient.colorPalette(amount: 8, inColorSpace: .hsl)
    }
}


public extension Theme {
    static func generateWithImage(image: Image) -> Theme {
        return Theme.example
    }
}



// MARK: --- Use these semantic colors in UI
// Return semantic colors that adapt to light/dark mode

public extension Theme {
    var bg0: Color {
        return Color(UIColor.dynamic(
            light: backgroundPalette[7],
            dark: backgroundPalette[0]
        ))
    }
    
    var bg1: Color {
        return Color(UIColor.dynamic(
            light: backgroundPalette[6],
            dark: backgroundPalette[1]
        ))
    }
    
    var bg2: Color {
        return Color(UIColor.dynamic(
            light: backgroundPalette[5],
            dark: backgroundPalette[2]
        ))
    }
    
    var bg3: Color {
        return Color(UIColor.dynamic(
            light: backgroundPalette[4],
            dark: backgroundPalette[3]
        ))
    }
    
    var primary: Color {
        return Color(UIColor.dynamic(
            light: primaryPalette[0],
            dark: primaryPalette[1]
        ))
    }
    
    var secondary: Color {
        return Color(UIColor.dynamic(
            light: primaryPalette[0].lighter(amount: 0.2),
            dark: primaryPalette[1].darkened(amount: 0.2)
        ))
    }
    
    var accent: Color {
        return Color(UIColor.dynamic(
            light: accentPalette[4],
            dark: accentPalette[5]
        ))
    }
}



public extension Theme {
    func nextBg(currentBg: Color) -> Color {
        switch currentBg {
        case bg0:
            print("returning bg1")
            return bg1
        case bg1:
            print("returning bg2")
            return bg2
        case bg2:
            return bg3
        default:
            return bg0
        }
    }
}




// MARK: --- UIColor extension for dynamic dark/light
// Return semantic colors that adapt to light/dark mode
public extension UIColor {
    static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}
