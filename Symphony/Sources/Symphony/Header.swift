//
//  PageHeader.swift
//  Passport
//
//  Created by Brandon Wright on 7/30/22.
//

import SwiftUI

public struct Header: View {
    
    public var title: String
    public var iconLeading : Icon?
    public var eyebrow : String?
    public var eyebrowIconLeading : Icon?

    public init (title: String = "Title", iconLeading: Icon? = nil, eyebrow: String? = nil, eyebrowIconLeading: Icon? = nil) {
        self.title = title
        self.iconLeading = iconLeading
        self.eyebrow = eyebrow
        self.eyebrowIconLeading = eyebrowIconLeading
    }
    
    public var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 0){
                
                // Eyebrow
                if (eyebrow != nil){
                    HStack(){
                        eyebrowIconLeading
                        Text(eyebrow ?? "Eyebrow")
                        
                    }
                }
                
                Text(title).font(.largeTitle).fontWeight(.bold)
            }
        }
    }
}

struct Header_Previews: PreviewProvider {
    
    static var previews: some View {
        Header(title: "View Header", iconLeading: Icon(name: "gear"), eyebrow: "dsfdsf")
    }
}
