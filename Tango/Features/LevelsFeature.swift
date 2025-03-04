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
    }

    enum Action {
        case selectLevel(Level)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .selectLevel:
                return .none
            }
        }
    }
}

struct LevelsView: View {

    let store: StoreOf<LevelsFeature>

    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(store.levels) { item in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: 80, height: 80)
                        Text(item.title)
                            .foregroundColor(.white)
                    }
                }
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
