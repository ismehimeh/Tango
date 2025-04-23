//
//  SettingsFeature.swift
//  Tango
//
//  Created by Sergei Vasilenko on 18.04.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SettingsFeature {
    
    @ObservableState
    struct State {
        var isShowClockIsOn = GameSettings.shared.showClock
        var isAutoCheckInOn = GameSettings.shared.autoCheck
    }
    
    enum Action {
        case isShowClockIsOnChanged(Bool)
        case isAutoCheckInOnChanged(Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .isShowClockIsOnChanged(let value):
                state.isShowClockIsOn = value
                GameSettings.shared.showClock = value
                return .none
            case .isAutoCheckInOnChanged(let value):
                state.isAutoCheckInOn = value
                GameSettings.shared.autoCheck = value
                return .none
            }
        }
    }
}
