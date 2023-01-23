//
//  SwiftUIView.swift
//  
//
//  Created by Brandon Wright on 11/16/22.
//

import SwiftUI

public struct ThemePaletteView: View {
    @EnvironmentObject var theme: Theme

    @State var showFull: Bool = false
    @State var showCircle: Bool = false

    public var body: some View {
        if(showFull){
            HStack{
                Circle().fill(theme.bg0)
                Rectangle().fill(theme.bg1)
                Rectangle().fill(theme.bg2)
                Rectangle().fill(theme.bg3)
                Rectangle().fill(theme.primary)
                Rectangle().fill(theme.secondary)
                Rectangle().fill(theme.accent)
            }
        }else{
            HStack{
                Circle().fill(theme.bg0)
                Circle().fill(theme.primary)
                Circle().fill(theme.accent)
            }
        }
    }
}

struct ThemePaletteView_Previews: PreviewProvider {
    static var theme = Theme(background: .white)

    static var previews: some View {
        ThemePaletteView()
            .environmentObject(theme)
    }
}
