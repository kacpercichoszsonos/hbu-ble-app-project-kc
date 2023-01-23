//
//  GridItem.swift
//  Passport
//
//  Created by Brandon Wright on 4/9/22.
//

import SwiftUI

public struct GridItem<LeadContent: View>: View {
    
    @EnvironmentObject var theme: Theme
    
    public let leadContent: () -> LeadContent
    public var title: String? = "Title"
    public var subtitle: String? = "Subtitle"


    public init(
        title: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder leadContent: @escaping () -> LeadContent)
    {
        self.title = title
        self.subtitle = subtitle
        self.leadContent = leadContent
    }
    
    
    // Init without leading or trailing views
    public init(title: String? = nil, subtitle: String? = nil) where LeadContent == EmptyView {
        self.init(
            title: title,
            subtitle: subtitle,
            leadContent: { EmptyView() }
        )
    }
    
    
    // Main Body of List Item
    public var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            // Leading
            leadContent()
            
            // Center
            VStack(alignment: .leading, spacing: 4){
                // Title Stack
                HStack{
                    if (title != nil){
                        Text(title!)
                            .font(.headline)
                            .fontWeight(.medium)
//                            .truncationMode(.tail)
                    }
                    
                }
                
                // Subtitle Stack
                HStack{
                    if (subtitle != nil){
                        Text(subtitle!)
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(theme.secondary)
                    }
                }
            }
                        
   
        }
        
    }
    
    
}



struct GridItem_Previews: PreviewProvider {
    static var theme = Theme.example
    static var previews: some View {
        
        GridItem(title: "A really long title that should get", subtitle: "A really long subtitle that should") {
            CustomImage(image: "https://m.media-amazon.com/images/M/MV5BYjhlZTMwMTEtM2Y0OS00NGM4LWE4YTgtYmQzY2E2ODk1ZmJiXkEyXkFqcGdeQXVyNDg4MjkzNDk@._V1_.jpg", width: 120, height: 120, radius: 16)
        }.environmentObject(theme)
        
    }
}






//public struct GridItem: View {
//    
//    public var image: CustomImage?
//    public var title: String?
//    public var subtitle: String?
//    public var iconLeading: Icon?
//    public var iconTrailing: Icon?
//    
//    
//    public init (image: CustomImage? = nil, title: String? = nil, subtitle: String? = nil, iconLeading: Icon? = nil, iconTrailing: Icon? = nil) {
//        self.image = image
//        self.title = title
//        self.subtitle = subtitle
//        self.iconLeading = iconLeading
//        self.iconTrailing = iconTrailing
//    }
//    
//    
//    public var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            
//            // Image
//            if (image != nil){
//                image
//            }
//            
//            HStack(alignment: .center, spacing: 16) {
//                
//                // Text
//                if(title != nil){
//                    VStack(alignment: .leading, spacing: 4){
//                            Text(title ?? "Title").font(.subheadline).fontWeight(.semibold).scaledToFit()
//                        
//                        if (subtitle != nil){
//                            Text(subtitle ?? "Subtitle").font(.caption).fontWeight(.regular).scaledToFit().opacity(0.6)
//                        }
//                        Spacer()
//                    }
//                }
//        
//                Spacer()
//                
//                // Trailing Icon
//                iconTrailing
//            }
//        }
//        .frame(maxWidth: image?.width ?? .infinity)
//    }
//}
//
//struct GridCell_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        GridItem(
//            image: CustomImage(image: "https://upload.wikimedia.org/wikipedia/en/4/47/Nao_-_For_All_We_Know_album_cover.jpeg", radius: 8), title: "Title",
//            subtitle: "Subtitle",
//            iconLeading: Icon(name: "plus"),
//            iconTrailing: Icon(name: "minus")
//        )
//        .background(.black)
//        .foregroundColor(.white)
//        .accentColor(.purple)
//    }
//}
//
