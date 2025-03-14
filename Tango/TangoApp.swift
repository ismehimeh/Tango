//
//  TangoApp.swift
//  Tango
//
//  Created by Sergei Vasilenko on 3.03.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct TangoApp: App {

    static let store = Store(initialState: LevelsFeature.State(levels: [level1, level2]))
    {
        LevelsFeature()
    }

    var body: some Scene {
        WindowGroup {
            LevelsView(store: TangoApp.store)
        }
    }
}
