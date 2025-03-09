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
        var gameCells: [[GameCell]]
        let gameConditions: [GameCellCondition]
    }

    enum Action {
        case tapCell(Int, Int)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tapCell(i, j):
                let cell = state.gameCells[i][j]
                guard cell.predefinedValue == nil else { return .none }

                if cell.value == nil {
                    state.gameCells[i][j].value = 0
                }
                else if cell.value == 0 {
                    state.gameCells[i][j].value = 1
                }
                else {
                    state.gameCells[i][j].value = nil
                }
                return .none
            }
        }
    }
}

struct GameCell {
    let predefinedValue: Int?
    var value: Int?

    init(predefinedValue: Int? = nil, value: Int? = nil) {
        self.predefinedValue = predefinedValue
        self.value = value
    }
}

struct GameCellCondition: Identifiable {
    enum Condition {
        case equal
        case opposite
    }

    let id = UUID()
    let condition: Condition
    let cellA: (Int, Int)
    let cellB: (Int, Int)
}

struct GameView: View {

    @Bindable var store: StoreOf<GameFeature>

    func cellBackgroundColor(_ i: Int, _ j: Int) -> Color {
        let cell = store.gameCells[i][j]
        if let _ = cell.predefinedValue {
            return Color.init(red: 238 / 255.0, green: 234 / 255.0, blue: 232 / 255.0)
        } else {
            return .white
        }
    }

    func cellValue(_ i: Int, _ j: Int) -> String? {
        let cell = store.gameCells[i][j]

        if let value = cell.predefinedValue {
            return value == 0 ? "🌞" : "🌚"
        }

        if let value = cell.value {
            return value == 0 ? "🌞" : "🌚"
        }

        return nil
    }

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "clock")
                    Text("0:01")
                    Spacer()
                    Button {
                        print("Clear!")
                    } label: {
                        Text("Clear")
                            .padding(.horizontal, 5)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }

                ZStack {
                    Rectangle()
                        .foregroundStyle(Color.init(red: 234 / 255.0, green: 227 / 255.0, blue: 217 / 255.0))
                        .aspectRatio(1, contentMode: .fit)
                    Grid(horizontalSpacing: 2, verticalSpacing: 2) {
                        ForEach(0..<6) { i in
                            GridRow {
                                ForEach(0..<6) { j in
                                    ZStack {
                                        Rectangle()
                                            .foregroundStyle(cellBackgroundColor(i, j))
                                        if let value = cellValue(i, j) {
                                            Text(value)
                                                .font(.title)
                                        }
                                    }
                                    .onTapGesture {
                                        store.send(.tapCell(i, j))
                                    }
                                }
                            }
                        }
                    }
                    .padding(2)

                }

                HStack {
                    Button {
                        print("Undo!")
                    } label: {
                        Text("Undo")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    
                    Button {
                        print("Hint!")
                    } label: {
                        Text("Hint")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }
                
                DisclosureGroup("How to play") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("•")
                            Text("Fill the grid so that each cell contains either a 🌞 or a 🌚.")
                        }
                        
                        HStack {
                            Text("•")
                            Text("No more than 2 🌞 or 🌚 may be next to each other, either vertically or horizontally.")
                        }
                        
                        HStack {
                            Text("•")
                            Text("🌞🌞✅")
                        }
                        .padding(.leading, 20)
                        
                        HStack {
                            Text("•")
                            Text("🌞🌞🌞❌")
                        }
                        .padding(.leading, 20)
                        
                        HStack {
                            Text("•")
                            Text("Each row (and column) must contain the same number of 🌞 and 🌚 .")
                        }
                        
                        HStack {
                            Text("•")
                            Text("Cells separated by an **=** sign must be of the same type.")
                        }
                        
                        HStack {
                            Text("•")
                            Text("Cells separated by an **X** sign must be of the opposite type.")
                        }
                        
                        HStack {
                            Text("•")
                            Text("Each puzzle has one right answer and can be solved via deduction (you should never have to make a guess).")
                        }
                    }
                }
                .frame(width: 300)
            }
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    GameView(store: Store(initialState: GameFeature.State(level: .init(title: "8"), gameCells: level1, gameConditions: level1Conditions)) {
        GameFeature()
    })
}


let level1: [[GameCell]] = [
    // 1
    [GameCell(), GameCell(), GameCell(predefinedValue: 0), GameCell(), GameCell(), GameCell()],
    // 2
    [GameCell(), GameCell(predefinedValue: 1), GameCell(predefinedValue: 1), GameCell(), GameCell(), GameCell()],
    // 3
    [GameCell(predefinedValue: 1), GameCell(predefinedValue: 1), GameCell(), GameCell(), GameCell(), GameCell()],
    // 4
    [GameCell(), GameCell(), GameCell(), GameCell(), GameCell(predefinedValue: 1), GameCell(predefinedValue: 0)],
    // 5
    [GameCell(), GameCell(), GameCell(), GameCell(predefinedValue: 1), GameCell(predefinedValue: 0), GameCell()],
    // 6
    [GameCell(), GameCell(), GameCell(), GameCell(predefinedValue: 0), GameCell(), GameCell()],
]

let level1Conditions: [GameCellCondition] = [
    .init(condition: .opposite, cellA: (0, 4), cellB: (0, 5)),
    .init(condition: .opposite, cellA: (0, 5), cellB: (1, 5)),
    .init(condition: .equal, cellA: (4, 0), cellB: (5, 0)),
    .init(condition: .equal, cellA: (5, 0), cellB: (5, 1)),
]
