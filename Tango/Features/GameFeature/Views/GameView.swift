//
//  GameView.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct GameView: View {

    enum Constants {
        static let cellPrefilledBackgroundColor = Color.init(red: 238 / 255.0, green: 234 / 255.0, blue: 232 / 255.0)
        static let cellBackgroundColor = Color.white
        static let fieldBackgroundColor = Color.init(red: 234 / 255.0, green: 227 / 255.0, blue: 217 / 255.0)
    }

    @Bindable var store: StoreOf<GameFeature>
    @State var cellEntries: [CellFramePreferenceKeyEntry] = []

    // MARK: - Views
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
        .toolbar {
            Button {
                store.send(.tapSettings)
            } label: {
                Image(systemName: "gearshape.fill")
            }
        }
        .onAppear {
            store.send(.startTimer)
        }
        .sheet(item: $store.scope(state: \.settings, action: \.settings)){ settingsStore in
            SettingsView(store: settingsStore)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }

    var topView: some View {
        HStack {
            if store.isClockVisible {
                Image(systemName: "clock")
                Text(store.timeString)
            }
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
        .alert($store.scope(state: \.alert, action: \.alert))
    }

    var gameFieldView: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Constants.fieldBackgroundColor)
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
            if store.isMistake && store.isMistakesVisible {
                Color.red.opacity(0.2)
                    .allowsHitTesting(false)
            }
            if store.isSolved {
                Color.green.opacity(0.2)
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

    // MARK: - Functions
    func cellBackgroundColor(_ i: Int, _ j: Int) -> Color {
        let cell = store.game.gameCells[i][j]
        if let _ = cell.predefinedValue {
            return Constants.cellPrefilledBackgroundColor
        } else {
            return Constants.cellBackgroundColor
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
}

#Preview {
    let game = Game(level1)
    let state = GameFeature.State(game: game)
    let store = Store(initialState: state) {
        GameFeature()
    }
    return NavigationStack {
        GameView(store: store)
    }
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
