//
//  HeadphonesImageView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 08/02/2023.
//

import SwiftUI

struct HeadphonesImageView: View {
    var body: some View {
        Image("duke_Img")
            .resizable()
            .padding(.horizontal)
            .scaledToFill()
            .mask(
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0),
                                                           Color.black.opacity(0.4),
                                                           Color.black,
                                                           Color.black,
                                                           Color.black.opacity(0.8),
                                                           Color.black.opacity(0),
                                                           Color.black.opacity(0),
                                                           Color.black.opacity(0)]),
                               startPoint: .bottom,
                               endPoint: .top)
            )
    }
}

struct HeadphonesImageView_Previews: PreviewProvider {
    static var previews: some View {
        HeadphonesImageView()
    }
}
