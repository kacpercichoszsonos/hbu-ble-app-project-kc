//
//  FeedHeader.swift
//  Passport
//
//  Created by Brandon Wright on 4/26/22.
//

import SwiftUI

public struct FeedHeader: View {

    public var image: String?
    
    public var body: some View {
        HStack(spacing: 16){
            
            HStack(spacing: 4){
                AsyncImage(
                    url: URL(string: image ?? ""),
                    content: { image in
                        image
                            .resizable()
                            .frame(width: 24, height: 24)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(100)

                    },
                    placeholder: {
                        Rectangle()
                            .fill(.background)
                            .frame(width: 24, height: 24)
                            .cornerRadius(100)
                    }
                    
                )
                
                Text("Netflix")
                    .font(.caption).bold()
            }
            
            Text("Because some context")
                .font(.caption)
                .opacity(0.6)
            
            Spacer()
            
            Button {
                print("Feed More Tapped")
            } label: {
                Image(systemName: "ellipsis")
                    .padding(4)
                    .cornerRadius(100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 48)
                            .stroke(Color.accentColor, lineWidth: 2)
                    )
            }
        }
    }
}

struct FeedHeader_Previews: PreviewProvider {
    
    static var previews: some View {
        FeedHeader()
            .background(.black)
            .foregroundColor(.white)
            .accentColor(.purple)
    }
}
