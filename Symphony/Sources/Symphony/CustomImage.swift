//
//  CustomImage.swift
//  Symphony
//
//  Created by Brandon Wright on 6/22/22.
//

import SwiftUI
import NukeUI

public struct CustomImage: View {
    @EnvironmentObject var theme: Theme
    
    
    var image: String
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var radius: CGFloat = 16.0
    var fillColor: Color = Color(hexString: "#444444")
    
    public init (image: String, width: CGFloat? = .infinity, height: CGFloat? = .infinity, radius: CGFloat? = 16.0, fillColor: Color = Color(hexString: "#444444")) {
        self.image = image
        self.width = width ?? .infinity
        self.height = height ?? .infinity
        self.fillColor = fillColor
        self.radius = radius ?? 16.0
    }
    
    public var body: some View {
        
        //        Rectangle()
        //            .fill(fillColor)
        //            .frame(width: width, height: height)
        //            .cornerRadius(radius)
        
//        Image(image)
        
        if (UIImage(named: image) != nil) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .background(fillColor)
                .cornerRadius(radius)
        }else{
            
            LazyImage(url: URL(string: image)) { state in
                if let image = state.image {
                    image
                    //                    .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .background(theme.bg1)
                        .cornerRadius(radius)
                } else if state.error != nil {
                    // Indicates an error
                    theme.bg2
                        .frame(width: width, height: height)
                        .cornerRadius(radius)

                    
                } else {
                    theme.bg2 // Acts as a placeholder
                }
            }.animation(nil)
        }
//        LazyImage(source: URL(string: image), content: { image in
//            image
//                .resizable()
//                .scaledToFill()
//                .frame(width: width, height: height)
//                .background(fillColor)
//                .cornerRadius(radius)
//
//        })
            
//            .resizable()
//            .scaledToFill()
//            .frame(width: width, height: height)
//            .background(fillColor)
//            .cornerRadius(radius)
        
        
//        AsyncImage(url: URL(string: image)) { image in
//            image
//                .resizable()
//                .scaledToFill()
//                .frame(width: width, height: height)
//                .background(fillColor)
//                .cornerRadius(radius)
//
//        } placeholder: {
//            fillColor
//                .frame(width: width, height: height)
//                .cornerRadius(radius)
//        }
//        .frame(width: 250, height: 250)
        
        
        
        
        
        
        //        if (UIImage(named: image) != nil) {
        //            Image(image)
        //                .resizable()
        //                .scaledToFill()
        //                .frame(width: width, height: height)
        //                .background(fillColor)
        //                .cornerRadius(radius)
        //        }else if (UIImage(systemName: image) != nil) {
        //            Image(systemName: image)
        //                .resizable()
        //                .scaledToFill()
        //                .frame(width: width, height: height)
        //                .cornerRadius(radius)
        //        }else{
        //            AsyncImage(url: URL(string: image)) { newImage in
        //                switch newImage {
        //                case .empty:
        //                    // Placeholder
        //                    Rectangle()
        //                        .fill(fillColor)
        //                        .frame(width: width, height: height)
        //                        .cornerRadius(radius)
        //                case .success(let newImage):
        //                    newImage
        //                        .resizable()
        //                        .scaledToFill()
        //                        .frame(width: width, height: height)
        //                        .cornerRadius(radius)
        //                case .failure:
        //                    Image(systemName: image)
        //                @unknown default:
        //                    // Since the AsyncImagePhase enum isn't frozen,
        //                    // we need to add this currently unused fallback
        //                    // to handle any new cases that might be added
        //                    // in the future:
        //                    EmptyView().frame(width: width, height: height)
        //                }
        //            }
        //        }
        
    }
}

struct CustomImage_Previews: PreviewProvider {
    static let theme = Theme.example
    
    static var previews: some View {
        CustomImage(image: "product", width: 280, height: 160, radius: 100)
            .environmentObject(theme)
    }
}
