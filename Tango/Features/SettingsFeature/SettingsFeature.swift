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
        var isShowClockIsOn = true
        var isAutoCheckInOn = true
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
                return .none
            case .isAutoCheckInOnChanged(let value):
                state.isAutoCheckInOn = value
                return .none
            }
        }
    }
}
