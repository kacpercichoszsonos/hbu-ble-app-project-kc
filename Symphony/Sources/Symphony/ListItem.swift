//
//  ListItem.swift
//  Passport
//
//  Created by Brandon Wright on 6/17/22.
//

import SwiftUI

public struct ListItem<LeadContent: View, TrailContent: View>: View {
    
    public let leadContent: () -> LeadContent
    public let trailContent: () -> TrailContent
    
    public var title: String = "Title"
    public var subtitle: String?
        

    public init(title: String = "Title", subtitle: String? = nil, @ViewBuilder leadContent: @escaping () -> LeadContent, @ViewBuilder trailContent: @escaping () -> TrailContent) {
        self.title = title
        self.subtitle = subtitle
        self.leadContent = leadContent
        self.trailContent = trailContent
    }
    
    
    // Init without leading or trailing views
    public init(title: String, subtitle: String? = nil) where LeadContent == EmptyView, TrailContent == EmptyView {
        self.init(
            title: title,
            subtitle: subtitle,
            leadContent: { EmptyView() },
            trailContent: { EmptyView() }
        )
    }
    
    // Only Leading
    public init(title: String, subtitle: String? = nil, @ViewBuilder leadContent: @escaping () -> LeadContent) where TrailContent == EmptyView {
        self.init(
            title: title,
            subtitle: subtitle,
            leadContent: leadContent,
            trailContent: {EmptyView()}
        )
    }
    
    // Only Trailing
    public init(title: String, subtitle: String? = nil, @ViewBuilder trailContent: @escaping () -> TrailContent) where LeadContent == EmptyView {
        self.init(
            title: title,
            subtitle: subtitle,
            leadContent: { EmptyView() },
            trailContent: trailContent
        )
    }

    
    // Main Body of List Item
    public var body: some View {
        
        HStack(alignment: .center, spacing: 16) {
            
            // Leading
            leadContent()
            
            // Center
            VStack(alignment: .leading, spacing: 4){
                // Title Stack
                HStack{
                    Text(title).font(.headline).fontWeight(.medium)
                }
                
                // Subtitle Stack
                HStack{
                    if (subtitle != nil){
                        Text(subtitle ?? "Subtitle").font(.subheadline).fontWeight(.regular).opacity(0.6)
                    }
                }
            }
            
            Spacer()
            
            // Trailing
            trailContent()
        }
    }
    
    
}


struct ListItem_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ForEach(ColorScheme.allCases, id: \.self) {
            
            VStack(alignment: .leading, spacing: 8) {
                
                ListItem(title: "test", subtitle: "Test")
                
                ListItem(title: "Test") {
                    Text("Header")
                        .font(.title)
                    Text("Header subtitle")
                        .font(.caption)
                } trailContent: {
                    Image(systemName: "tortoise.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                }
                
              
                
                ListItem(title: "Test")
                
                
            }
            .preferredColorScheme($0)
            
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
        .ignoresSafeArea()
        
    }
}
