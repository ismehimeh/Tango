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

    static let store = Store(initialState: LevelsFeature.State(levels: [Level(title: "1"),
                                                                        Level(title: "2"),
                                                                        Level(title: "3")]))
    {
        LevelsFeature()
    }

    var body: some Scene {
        WindowGroup {
            LevelsView(store: TangoApp.store)
        }
    }
}
