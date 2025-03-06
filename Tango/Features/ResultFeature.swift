//
//  ResultFeature.swift
//  Tango
//
//  Created by Sergei Vasilenko on 6.03.2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ResultFeature {

    @ObservableState
    struct State {

    }

    enum Action {
        case tapGoToLevels
        case tapNextLevel
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .tapGoToLevels:
                    return .none
                case .tapNextLevel:
                    return .none
            }
        }
    }
}

struct ResultView: View {
    var body: some View {
        Text("Fuck you!")
    }
}
