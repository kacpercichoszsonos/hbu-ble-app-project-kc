//
//  DukeSettingsView.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 07/02/2023.
//

import SwiftUI
import SonosSymphony
import Symphony

private let maxCellHeight: CGFloat = 60

struct DukeSettingsView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 5) {
                SymphonyPageHeader(title: "Kacper's Duke", eyebrowText: "Duke", icon: Image("Plus")) {
                    //TODO:
                }
                .foregroundColor(Color.primary)
                .frame(maxWidth: .infinity)
                HeadphonesImageView()
                    .padding(.top, -125)
                ForEach(loadJson()!, id: \.header) { setting in
                    SettingsSectionView(section: setting)
                }
            }
            .padding(.horizontal)
        }
        .background(Color.sonosBackgroundSecondary.ignoresSafeArea())
    }

    private func loadJson() -> [Section]? {
        if let url = Bundle.main.url(forResource: "settings(1)", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try JSONDecoder().decode(Settings.self, from: data)
                return jsonData.sections
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}

