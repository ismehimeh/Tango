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
            case .path(.element(_, action: .showGameResult(.tapGoToLevels))):
                let _ = state.path.popLast()
                let _ = state.path.popLast()
                return .none
            case let .path(.element(id: id, action: .showGameResult(.tapNextLevel))):
                guard let finishedLevel = state.path[id: id]?.showGameResult?.finishedLevel else { return .none }

                let finishedLevelIndex = state.levels.firstIndex { $0.id == finishedLevel.id }
                guard let finishedLevelIndex = finishedLevelIndex else { return .none }
                guard finishedLevelIndex + 1 < state.levels.count else { return .none }

                let nextLevel = state.levels[finishedLevelIndex + 1]

                let _ = state.path.popLast()
                let _ = state.path.popLast()
                state.path.append(.startGame(GameFeature.State(level: nextLevel, gameCells: level1)))
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
                        // TODO: should this navigation link even be here? if we do all of this in reducer? looks like something left from the previous version
                        NavigationLink(state: LevelsFeature.Path.State.startGame(GameFeature.State(level: level, gameCells: level1))) {
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
