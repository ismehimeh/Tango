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
        case tapPop
    }

    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapGoToLevels:
                return .none
            case .tapNextLevel:
                return .none
            case .tapPop:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}

struct ResultView: View {
    @Bindable var store: StoreOf<ResultFeature>

    var body: some View {
        VStack {
            Text("Play next levels")
            Button {
                store.send(.tapGoToLevels)
            } label: {
                Text("Main Page")
            }
            Button {
                store.send(.tapPop)
            } label: {
                Text("TEMP: Just pop it")
            }
        }
        .navigationBarBackButtonHidden()
    }
}
