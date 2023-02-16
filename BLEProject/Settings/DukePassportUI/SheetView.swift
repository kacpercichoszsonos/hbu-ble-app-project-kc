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
    @StateObject var viewModel: SettingsViewModel
    @State var headerTitle: String
    @State var sheetSection: [SheetSection]?
    @State var isAncOn: Bool? = false
    @State var isAncOff: Bool? = false
    @State private var volumeLimitSlider: Float = 100.0
    @State private var isMuted: Bool = false

    var body: some View {
        SymphonyPageHeader(title: headerTitle)
            .padding(.vertical)
        VStack {
            if let sheetSection {
                ForEach(sheetSection, id:\.listViewTitle) { section in
                    if section.listViewTitle == "Limit" {
                        VStack {
                            HStack {
                                Text("\(section.listViewTitle)")
                                Spacer()
                                Text("\(Int(volumeLimitSlider))")
                            }
                            HStack(spacing: 10) {
                                Icon(name: "speaker")
                                SymphonyRangeSlider(value: $volumeLimitSlider, isMuted: $isMuted)
                                    .onChange(of: volumeLimitSlider) { newValue in
                                        self.viewModel.writeData(setting: .volume, value: newValue)
                                    }
                                Icon(name: "speaker.wave.3")
                            }
                            .onReceive(self.viewModel.$dukeModel, perform: { dukeModel in
                                self.volumeLimitSlider = self.viewModel.setupVolumeSlider()
                            })
                            .onChange(of: self.viewModel.isDukeConnected, perform: { _ in
                                self.volumeLimitSlider = self.viewModel.setupVolumeSlider()
                            })
                        }
                        .padding(.all)
                        Divider()
                            .padding(.leading)
                        ListItem(title: "Reset", yellowText: true, trailContent: {
                            Image("reset")
                        })
                    } else {
                        ListItem(title: section.listViewTitle, trailContent: {
                            if section.listViewTitle == "On" {
                                Image(systemName: self.isAncOn ?? false ? "checkmark" : "")
                            } else {
                                Image(systemName: self.isAncOff ?? false ? "checkmark" : "")
                            }
                        })
                        .onTapGesture {
                            withAnimation {
                                if section.listViewTitle == "On" {
                                    if !(self.isAncOn ?? false) {
                                        self.isAncOn?.toggle()
                                        self.isAncOff = !(self.isAncOn ?? false)
                                    }
                                } else {
                                    if !(self.isAncOff ?? false) {
                                        self.isAncOff?.toggle()
                                        self.isAncOn = !(self.isAncOff ?? false)
                                    }
                                }
                                self.viewModel.writeData(setting: .anc, value: self.isAncOn)
                            }
                        }
                    }
                }
            } else {
                ListItem(title: "Add TrueRoom", trailContent: {
                    Image("Shape")
                })
                ListItem(title: "Add a Voice Assistant", trailContent: {
                    Image("Speech")
                })
            }
        }
        .onAppear {
            if self.viewModel.getAnc() {
                self.isAncOn = true
            } else {
                self.isAncOff = true
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.sonosBackgroundTertiary)
        .cornerRadius(10)
        .padding([.vertical])
        .presentationDetents([.large])
        Spacer(minLength: 200)
    }
}
