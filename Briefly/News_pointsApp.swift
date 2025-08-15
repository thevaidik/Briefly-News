//
//  News_pointsApp.swift
//  News points
//
//  Created by Vaidik Dubey on 13/01/25.
//

import SwiftUI

@main
struct News_pointsApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var rssManager = RSSCategoryManager()
    
    var body: some Scene {
        WindowGroup {
            SelectionView()
                .environmentObject(themeManager)
                .environmentObject(rssManager)
        }
    }
}

