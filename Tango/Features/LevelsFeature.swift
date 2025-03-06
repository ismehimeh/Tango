//
//  LevelsFeature.swift
//  Tango
//
//  Created by Sergei Vasilenko on 4.03.2025.
//

import SwiftUI
import ComposableArchitecture

struct Level: Identifiable {
    var id = UUID()
    var title: String // TODO: I am not planning to use it, just need it to distinguish cell for now
}

@Reducer
struct LevelsFeature {

    @ObservableState
    struct State {
        var levels: [Level]
        var path = StackState<Path.State>()
    }

    enum Action {
        case selectLevel(Level)
        case path(StackActionOf<Path>)
    }

    @Reducer
    enum Path {
        case startGame(GameFeature)
        case showGameResult(ResultFeature)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .selectLevel:
                return .none
            case let .path(.element(id: id, action: .showGameResult(.tapGoToLevels))):
                let _ = state.path.popLast()
                let _ = state.path.popLast()
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

struct LevelsView: View {

    @Bindable var store: StoreOf<LevelsFeature>

    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(store.levels) { level in
                        NavigationLink(state: LevelsFeature.Path.State.startGame(GameFeature.State(level: level))) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                    .frame(width: 80, height: 80)
                                Text(level.title)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        } destination: { store in
            switch store.case {
            case let .startGame(store):
                GameView(store: store)
            case let .showGameResult(store):
                ResultView(store: store)
            }
        }
    }
}

#Preview {
    let levels = (1...100).map { Level(title: "\($0)") }
    return LevelsView(store: Store(initialState: LevelsFeature.State(levels: levels)) {
        LevelsFeature()
    })
}
