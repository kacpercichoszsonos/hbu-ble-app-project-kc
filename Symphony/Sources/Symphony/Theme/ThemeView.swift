//
//  ThemeView.swift
//  Passport
//
//  Created by Brandon Wright on 7/18/22.
//

import SwiftUI
import NukeUI

public struct ThemeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var theme: Theme
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8){
            
            Text("Theme Explorer").viewTitle()
            
            Text("These palettes are dynamically generated and used to sample the theme's semantic values from").foregroundColor(theme.secondary)
            
            Spacer()
            
            
            Group{
                Text("Background Palete").font(.subheadline).fontWeight(.bold)
                HStack (spacing: 4){
                    ForEach(theme.backgroundPalette.indices, id: \.self){ swatch in
                        Rectangle().fill(Color(theme.backgroundPalette[swatch]))
                    }
                }.frame(height: 44)
            }
            
            
            Group{
                Text("Primary Palete").font(.subheadline).fontWeight(.bold)
                HStack (spacing: 4){
                    ForEach(theme.primaryPalette.indices, id: \.self){ swatch in
                        Rectangle().fill(Color(theme.primaryPalette[swatch]))
                    }
                }.frame(height: 44)
            }
            
            Group{
                Text("Accent Palete").font(.subheadline).fontWeight(.bold)
                HStack (spacing: 4){
                    ForEach(theme.accentPalette.indices, id: \.self){ swatch in
                        Rectangle().fill(Color(theme.accentPalette[swatch]))
                    }
                }.frame(height: 44)
            }
            
            Spacer()
            
            Group{
                Text("Semantic Theme").font(.subheadline).fontWeight(.bold)
                Text("These values are the semantic theme values used throughout the UI. They adapt to light and dark mode.").foregroundColor(theme.secondary)
                
                
                HStack (spacing: 4){
                    VStack{
                        Rectangle().fill(theme.bg0)
                        Text("bg0").font(.caption)
                    }
                    VStack{
                        Rectangle().fill(theme.bg1)
                        Text("bg1").font(.caption)
                    }
                    VStack{
                        Rectangle().fill(theme.bg2)
                        Text("bg2").font(.caption)
                    }
                    VStack{
                        Rectangle().fill(theme.bg3)
                        Text("bg3").font(.caption)
                    }
                    VStack{
                        Rectangle().fill(theme.primary)
                        Text("primary").font(.caption)
                    }
                    VStack{
                        Rectangle().fill(theme.secondary)
                        Text("secondary").font(.caption).lineLimit(1)
                        
                    }
                    VStack{
                        Rectangle().fill(theme.accent)
                        Text("accent").font(.caption)
                    }
                }.frame(height: 200)
            }
            
        }
        .cornerRadius(8)
        //        .frame(width: .infinity, height: 64)
    }
}




public struct TestTheme: View {
    @State var theme: Theme = Theme(background: .white)
    @StateObject private var image = FetchImage()
//    let url = URL(string: "https://f4.bcbits.com/img/a1687463834_10.jpg")!
//    let url = URL(string: "https://f4.bcbits.com/img/0025486021_10.jpg")!
    let url = URL(string: "https://f4.bcbits.com/img/a1056033757_10.jpg")
    
    public init () {}
    
    public var body: some View {
        ScrollView{
            VStack{
                image.view?.resizable().scaledToFit()
                Rectangle().fill(Color(image.image?.averageColor ?? .clear)).frame(height: 100)
                ThemeView(theme: Theme(background: Color(image.image?.averageColor ?? .black)))
                
            }.padding()
        }
        
        .onAppear {
            image.load(url)
        }
        .onChange(of: image.image, perform: { newValue in
            self.theme = Theme(background: Color(newValue?.averageColor ?? .black))
//            self.theme = Theme(background: .green)
        })
//        .onDisappear { image.reset() }
        .background(self.theme.bg0)
        .foregroundColor(self.theme.primary)
        .accentColor(self.theme.accent)
    }

}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            TestTheme().preferredColorScheme($0)
        }
    }
}
