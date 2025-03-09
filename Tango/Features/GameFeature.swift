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
                print("Clear!")
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

struct CellView: View {
    let row: Int
    let column: Int
    let backgroundColor: Color
    let cellContent: String?

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColor)
            if let text = cellContent {
                Text(text)
                    .font(.title)
            }
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(
                        key: CellFramePreferenceKey.self,
                        value: [CellFramePreferenceKeyEntry(row: row,
                                                            column: column,
                                                            rect: geo.frame(in: .named("grid")))]
                    )
            }
        )
    }
}

struct ConditionView: View {
    let condition: GameCellCondition.Condition

    var body: some View {
        Circle()
            .frame(width: 20, height: 20)
            .foregroundStyle(.white)
            .overlay {
                switch condition {
                case .equal:
                    Image(systemName: "equal")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color(red: 135 / 255.0, green: 114 / 255.0, blue: 85 / 255.0))
                case .opposite:
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color(red: 135 / 255.0, green: 114 / 255.0, blue: 85 / 255.0))
                }
            }
    }
}

