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
        var game: Game
        var isMistake = false
        var isSolved = false
    }

    enum Action {
        case tapCell(Int, Int)
        case tapClear
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tapCell(i, j):
                let cell = state.game.gameCells[i][j]
                guard cell.predefinedValue == nil else { return .none }

                if cell.value == nil {
                    state.game.gameCells[i][j].value = 0
                }
                else if cell.value == 0 {
                    state.game.gameCells[i][j].value = 1
                }
                else {
                    state.game.gameCells[i][j].value = nil
                }

                state.isMistake = !state.game.isFieldValid()
                state.isSolved = state.game.isSolved()

                return .none
            case .tapClear:
                state.game.gameCells = state.game.gameCells.map { row in
                    row.map { cell in
                        GameCell(predefinedValue: cell.predefinedValue)
                    }
                }
                state.isMistake = !state.game.isFieldValid()
                state.isSolved = state.game.isSolved()
                return .none
            }
        }
    }
}
