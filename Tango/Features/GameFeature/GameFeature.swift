//
//  GameFeature.swift
//  Tango
//
//  Created by Sergei Vasilenko on 4.03.2025.
//

import SwiftUI
import ComposableArchitecture

struct Game {
    var gameCells: [[GameCell]]
    let gameConditions: [GameCellCondition]

    func isRowValid(_ row: Int) -> Bool {
        let row = gameCells[row]
        let zeros = row.count { $0.value == 0 }
        let ones = row.count { $0.value == 1 }

        guard
            zeros <= 3,
            ones <= 3
        else {
            return false
        }

        return true
    }
}

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
        case tapClear
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
            case .tapClear:
                state.gameCells = state.gameCells.map { row in
                    row.map { cell in
                        GameCell(predefinedValue: cell.predefinedValue)
                    }
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
    @State var cellEntries: [CellFramePreferenceKeyEntry] = []

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
                topView
                gameFieldView
                undoAndHintView
                howToPlayView
            }
            .padding(.horizontal, 15)
        }
    }

    var topView: some View {
        HStack {
            Image(systemName: "clock")
            Text("0:01")
            Spacer()
            Button {
                store.send(.tapClear)
            } label: {
                Text("Clear")
                    .padding(.horizontal, 5)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
    }

    var gameFieldView: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color.init(red: 234 / 255.0, green: 227 / 255.0, blue: 217 / 255.0))
                .aspectRatio(1, contentMode: .fit)
            Grid(horizontalSpacing: 2, verticalSpacing: 2) {
                ForEach(0..<6) { i in
                    GridRow {
                        ForEach(0..<6) { j in
                            ZStack {
                                CellView(row: i,
                                         column: j,
                                         backgroundColor: cellBackgroundColor(i, j),
                                         cellContent: cellValue(i, j))
                            }
                            .onTapGesture {
                                store.send(.tapCell(i, j))
                            }
                        }
                    }
                }
            }
            .padding(2)
            .onPreferenceChange(CellFramePreferenceKey.self) { value in
                cellEntries = value
            }
            .coordinateSpace(name: "grid")

            ZStack {
                ForEach(store.gameConditions) { condition in
                    let cellA = cellEntries.last(where: { $0.row == condition.cellA.0 && $0.column == condition.cellA.1})
                    let cellB = cellEntries.last(where: { $0.row == condition.cellB.0 && $0.column == condition.cellB.1})
                    if let cellA = cellA, let cellB = cellB {
                        let midPoint = CGPoint(x: (cellA.rect.midX + cellB.rect.midX) / 2,
                                               y: (cellA.rect.midY + cellB.rect.midY) / 2)
                        ConditionView(condition: condition.condition)
                            .position(midPoint)
                    }
                }
            }
        }
    }

    var undoAndHintView: some View {
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
    }

    var howToPlayView: some View {
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
}

#Preview {
    GameView(store: Store(initialState: GameFeature.State(level: .init(title: "8"), gameCells: level1, gameConditions: level1Conditions)) {
        GameFeature()
    })
}

struct CellFramePreferenceKey: PreferenceKey {
    typealias Value = [CellFramePreferenceKeyEntry]

    static var defaultValue: [CellFramePreferenceKeyEntry] = []

    static func reduce(value: inout [CellFramePreferenceKeyEntry],
                       nextValue: () -> [CellFramePreferenceKeyEntry])
    {
        value.append(contentsOf: nextValue())
    }
}

struct CellFramePreferenceKeyEntry: Hashable {
    let row: Int
    let column: Int
    let rect: CGRect
}
