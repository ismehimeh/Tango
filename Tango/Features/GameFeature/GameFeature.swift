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
        return isCellsArrayValid(row)
    }

    func isColumnValid(_ column: Int) -> Bool {
        let column = gameCells.map { $0[column] }
        return isCellsArrayValid(column)
    }

    func isFieldValid() -> Bool {
        let isRowsValid = (0..<6).map { isRowValid($0) }.allSatisfy { $0 }
        let isColumnsValid = (0..<6).map { isColumnValid($0) }.allSatisfy { $0 }
        return isRowsValid && isColumnsValid
    }

    func isSolved() -> Bool {
        let isAllCellsFilled = gameCells.flatMap { $0 }.allSatisfy { $0.value != nil || $0.predefinedValue != nil}
        return isAllCellsFilled && isFieldValid()
    }

    private func isCellsArrayValid(_ cells: [GameCell]) -> Bool {
        let zeroes = cells.count { $0.value == 0 }
        let ones = cells.count { $0.value == 1 }

        guard
            zeroes <= 3,
            ones <= 3
        else {
            return false
        }

        var zeroesCount = 0
        var onesCount = 0
        for cell in cells {
            if cell.value == 0 {
                zeroesCount += 1
                onesCount = 0
            }
            if cell.value == 1 {
                zeroesCount = 0
                onesCount += 1
            }
            if cell.value == nil {
                zeroesCount = 0
                onesCount = 0
            }
            guard zeroesCount <= 2 && onesCount <= 2 else { return false }
        }

        return true
    }
}

@Reducer
struct GameFeature {

    @ObservableState
    struct State {
        let level: Level
        var game: Game
        var isMistake = false
        var isSolved = false
    }

    enum Action {
        case tapCell(Int, Int)
        case tapClear
    }

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

                state.isMistake = !state.game.isFieldValid()
                state.isSolved = state.game.isSolved()
                return .none
            case .tapClear:
                state.game.gameCells = state.game.gameCells.map { row in
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
    private var _value: Int?
    
    var value: Int? {
        get {
            predefinedValue ?? _value
        }

        set {
            _value = newValue
        }
    }

    init(predefinedValue: Int? = nil, value: Int? = nil) {
        self.predefinedValue = predefinedValue
        self._value = value
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
        let cell = store.game.gameCells[i][j]
        if let _ = cell.predefinedValue {
            return Color.init(red: 238 / 255.0, green: 234 / 255.0, blue: 232 / 255.0)
        } else {
            return .white
        }
    }

    func cellValue(_ i: Int, _ j: Int) -> String? {
        let cell = store.game.gameCells[i][j]

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
                ForEach(store.game.gameConditions) { condition in
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
        .overlay {
            if store.isMistake {
                Color.red.opacity(0.1)
                    .allowsHitTesting(false)
            }
            if store.isSolved {
                Color.green.opacity(0.1)
                    .allowsHitTesting(false)
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
    let game = Game(gameCells: level1,
                    gameConditions: level1Conditions)
    let state = GameFeature.State(level: .init(title: "8"),
                                  game: game)
    let store = Store(initialState: state) {
        GameFeature()
    }
    return GameView(store: store)
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
