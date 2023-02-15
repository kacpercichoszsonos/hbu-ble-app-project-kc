//
//  SettingsSectionView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 08/02/2023.
//

import SwiftUI
import SonosSymphony
import Symphony

enum ActionIcon: String {
    case arrow
    case sonosSwitch
    case plus
    case book
}

struct SettingsSectionView: View {
    @StateObject var viewModel: SettingsViewModel
    let section: Section
    @State var isHeadTrackingOn: Bool = false
    @State var isSonosSpatialOn: Bool = false
    @State var anyOtherSwitch: Bool = false
    var body: some View {
        SymphonySectionHeader(title: section.header)
        VStack {
            ForEach(section.subsections, id: \.title) { subsection in
                ListItem(title: subsection.title, subtitle: subsection.subtitle ?? nil,
                leadContent: {
                    if let leadIcon = subsection.leadingIcon {
                        Image(leadIcon)
                            .resizable()
                            .frame(width: 20,height: 20)
                    }
                },
                trailContent: {
                    switch subsection.actionIcon {
                    case ActionIcon.arrow.rawValue:
                        if let actionText = subsection.actionText {
                            Text(actionText)
                                .foregroundColor(Color.sonosSecondary)
                        }
                        Image("arrow_right_Icon")
                    case ActionIcon.sonosSwitch.rawValue:
                        switch subsection.title {
                        case "Headtracking Always On":
                            SymphonySwitch(isOn: $isHeadTrackingOn)
                                .onChange(of: self.isHeadTrackingOn) { newValue in
                                    self.viewModel.writeData(setting: .headTracking, value: newValue)
                                }
                        case "Sonos Spatial":
                            SymphonySwitch(isOn: $isSonosSpatialOn)
                                .onChange(of: self.isSonosSpatialOn) { newValue in
                                    self.viewModel.writeData(setting: .sonosSpatial, value: newValue)
                                }
                        default:
                            SymphonySwitch(isOn: $anyOtherSwitch)
                        }
                    case ActionIcon.plus.rawValue:
                        Image("plus_Icon")
                    case ActionIcon.book.rawValue:
                        Image(systemName: "book")
                    default:
                        Image("home")
                    }
                })
                .frame(height: 60)
                .foregroundColor(subsection.yellowRow ?? false ? Color.sonosEastCoastAccent : Color.sonosPrimary)
                .listRowBackground(Color.sonosBackgroundTertiary)
                Divider()
                    .padding(.leading)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.sonosBackgroundTertiary)
        .cornerRadius(10)
        .padding(.vertical)
        .onAppear {
            (self.isSonosSpatialOn, self.isHeadTrackingOn) = self.viewModel.setupView()
        }
        if section.header == "Home Theatre Swap" {
            Spacer()
            ListItem(title: "Remove Home Theatre Swap", trailContent: {
                Image("remove_Icon")
            })
            .frame(height: 60)
            .foregroundColor(Color.sonosEastCoastAccent)
            .background(Color.sonosBackgroundTertiary)
        }
        if section.header == "Support" {
            ListItem(title: "Visit help center", eyebrown: "Need help with your product?", leadContent: {
                Image("help_Icon")
            },trailContent: {
                Image("remove_Icon")
            })
            .frame(height: 60)
            .background(Color.sonosBackgroundTertiary)
            .cornerRadius(10)
            Spacer()
        }
    }
}
