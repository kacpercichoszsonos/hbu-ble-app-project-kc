//
//  SheetView.swift
//  BLEProject
//
//  Created by Ashley Oldham on 15/02/2023.
//

import SwiftUI
import Symphony
import SonosSymphony

struct SheetView: View {
  @State var headerTitle: String
  @State var sheetSection: [SheetSection]?
  @State var isAncOn: Bool? = false

    var body: some View {
      SymphonyPageHeader(title: headerTitle)
        .padding(.all)
      VStack {
        if let sheetSection {
          ForEach(sheetSection, id:\.listViewTitle) { section in
            ListItem(title: section.listViewTitle, trailContent: {
              Image(systemName: isAncOn ?? false ? "checkmark" : "")
            })
            .onTapGesture {
              withAnimation {
                isAncOn?.toggle()
              }
            }
          }
        } else {
          ListItem(title: "Add TrueRoom", trailContent: {
            Image("shape")
          })
          ListItem(title: "Add a Voice Assistant", trailContent: {
            Image("speech")
          })
        }
      }
      .frame(maxWidth: .infinity)
      .background(Color.sonosBackgroundTertiary)
      .cornerRadius(10)
      .padding([.vertical, .horizontal])
      .presentationDetents([.medium])
      Spacer()
    }
}

//struct SheetView_Previews: PreviewProvider {
//    static var previews: some View {
//      SheetView(headerTitle: "title", sheetSection: <#[SheetSection]#>)
//    }
//}
