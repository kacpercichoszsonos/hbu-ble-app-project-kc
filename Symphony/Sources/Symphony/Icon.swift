//
//  Icon.swift
//  Passport
//
//  Created by Brandon Wright on 7/19/22.
//

import SwiftUI

public struct Icon: View {
    public var name: String
    public var size: CGFloat = 24.0
    
    public init (name: String = "wifi", size: CGFloat = 24.0) {
        self.name = name
        self.size = size
    }
    
    public var body: some View {
        
        // First we check if we have an image asset
        // Fallback to system icon
        // or display a default icon
        
        if (UIImage(named: name) != nil) {
            Image(name)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }else if (UIImage(systemName: name) != nil) {
            Image(systemName: name)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }else{
            Image(systemName: "wifi")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(name: "wifi")
    }
}
