//
//  Header.swift
//  Passport
//
//  Created by Brandon Wright on 6/22/22.
//

import SwiftUI

public struct SectionHeader: View {

    public var title: String
    public var subtitle: String?
    public var eyebrow: String?
    public var iconLeading : Icon?
    public var iconTrailing : Icon?
    public var textTrailing : String?
    


    public init(title: String, subtitle: String? = nil, eyebrow: String? = nil, iconLeading: Icon? = nil, iconTrailing: Icon? = nil, textTrailing: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.eyebrow = eyebrow
        self.iconLeading = iconLeading
        self.iconTrailing = iconTrailing
        self.textTrailing = textTrailing
    }
    
    
    
    public var body: some View {
        HStack(alignment: .center, spacing: 16){
            
            if (iconLeading != nil){
                iconLeading
            }

            
            VStack(alignment: .leading, spacing: 4){
                if (eyebrow != nil){
                    Text(eyebrow ?? "Eybrow")
                        .font(.caption).fontWeight(.regular).opacity(0.6)
                }
                
                Text(title)
                    .sectionTitle()
//                    .sectionTitle()
                
                if (subtitle != nil){
                    Text(subtitle ?? "Subtitle")
                        .SubTitleText()
                }
            }
            
            Spacer()
            
            if (textTrailing != nil){
                Text(textTrailing ?? "Action")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            if (iconTrailing != nil){
                iconTrailing
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
//        .padding(.leading, 24)
//        .padding(.trailing, 24)

        
        
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static let theme = Theme.example
    
    static var previews: some View {
        VStack(alignment: .leading, spacing: 24){
            SectionHeader(title: "Title")
                
            SectionHeader(title: "Title", subtitle: "Subtitle")

            SectionHeader(title: "Title", subtitle: "Subtitle", iconLeading: Icon(name: "wifi"))

            SectionHeader(title: "Title", subtitle: "Subtitle", iconTrailing: Icon(name: "wifi"))

            SectionHeader(title: "Title")

            SectionHeader(title: "Title", textTrailing: "Action")

        }
        .environmentObject(theme)

    }
}
