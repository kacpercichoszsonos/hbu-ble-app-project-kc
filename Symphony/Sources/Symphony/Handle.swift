//
//  Handle.swift
//  Passport
//
//  Created by Brandon Wright on 7/5/22.
//

import SwiftUI

public struct Handle: View {
    
    public init () {}
    
    public var body: some View {
        HStack(alignment: .center){
            Rectangle()
                .frame(width: 44, height: 4, alignment: .center)
                .cornerRadius(100)
                .opacity(0.1)
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity)
//        .padding(.bottom, 8)
    }
}

struct Handle_Previews: PreviewProvider {
    
    static var previews: some View {
        Handle()
    }
}
