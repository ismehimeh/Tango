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
        @Presents var alert: AlertState<Action.Alert>?
        @Presents var settings: SettingsFeature.State?
        var game: Game
        var isMistake = false
        var isSolved = false
        var secondsPassed = 0 {
            didSet {
                timeString = String(format: "%01d:%02d", secondsPassed / 60, secondsPassed % 60)
            }
        }
        var timeString = "0:00"
        var mistakeValidationID: UUID?
    }

    enum Action {
        case tapCell(Int, Int)
        case tapClear
        case tapSettings
        case settings(PresentationAction<SettingsFeature.Action>)
        case alert(PresentationAction<Alert>)
        case startTimer
        case timerUpdated
        case validateMistake(UUID)
        enum Alert {
            case confirmClear
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.continuousClock) var clock
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
                
                let mistakeId = UUID()
                state.mistakeValidationID = mistakeId
                state.isMistake = false
                state.isSolved = state.game.isSolved()
                
                return .run { send in
                    try await Task.sleep(for: .seconds(1))
                    await send(.validateMistake(mistakeId))
                }
            case let .validateMistake(id):
                guard id == state.mistakeValidationID else { return .none }
                state.isMistake = !state.game.isFieldValid()
                return .none
            case .tapClear:
                state.alert = .confirmClear
                return .none
            case .tapSettings:
                state.settings = SettingsFeature.State()
                return .none
            case .settings:
                return .none
            case .alert(.presented(.confirmClear)):
                state.game.gameCells = state.game.gameCells.map { row in
                    row.map { cell in
                        GameCell(predefinedValue: cell.predefinedValue)
                    }
                }
                state.isMistake = !state.game.isFieldValid()
                state.isSolved = state.game.isSolved()
                return .none
            case .alert:
                return .none
            case .startTimer:
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerUpdated)
                    }
                }
            case .timerUpdated:
                state.secondsPassed += 1
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$settings, action: \.settings) {
            SettingsFeature()
        }
    }
}


extension AlertState where Action == GameFeature.Action.Alert {

    static let confirmClear = Self {
        TextState("You sure?")
    } actions: {
        ButtonState(role: .destructive, action: .confirmClear) {
            TextState("Clear")
        }
    }
}
