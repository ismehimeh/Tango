//
//  GameFeature.swift
//  Tango
//
//  Created by Sergei Vasilenko on 4.03.2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct GameFeature {

    @ObservableState
    struct State {
        let level: Level
    }

    enum Action {

    }
}

struct GameView: View {

    let store: StoreOf<GameFeature>

    var body: some View {
        NavigationLink(state: LevelsFeature.Path.State.showGameResult(ResultFeature.State()))
        {
            Text("Finish game")
            .navigationTitle(Text(store.level.title))
        }
    }
}

#Preview {
    GameView(store: Store(initialState: GameFeature.State(level: .init(title: "8"))) {
        GameFeature()
    })
}
