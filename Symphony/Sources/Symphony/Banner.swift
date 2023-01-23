//
//  Banner.swift
//  Passport
//
//  Created by Brandon Wright on 7/30/22.
//

import SwiftUI

public struct Banner: View {
    
    public var title: String
    public var subtitle: String?
    public var image: CustomImage?
    public var height: CGFloat
    
    
    public init (title: String = "Banner Title", subtitle: String? = nil, image: CustomImage? = nil, height: CGFloat = 150) {
        self.title = title
        self.subtitle = subtitle ?? nil
        self.image = image ?? nil
        self.height = height
    }
    
    
    public var body: some View {
        HStack(alignment: .center, spacing: 4){
            
            VStack(alignment: .leading, spacing: 0){
                Spacer()
                Text(title)
                    .font(.title3)
                    .fontWeight(.medium)
                Spacer()
                if (subtitle != nil){
                    Text(subtitle ?? "Subtitle")
                        .font(.caption)
                        .fontWeight(.regular)
                }
            }.padding()
            
            // Trailing Column
            VStack{
                if (image != nil){
                    image.zIndex(-1)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: height)
        
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Banner()
            .frame(width: .infinity, height: 150)
    }
}
