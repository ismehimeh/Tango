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
    }

    enum Action {

    }
}

struct GameView: View {

    let store: StoreOf<GameFeature>

    var body: some View {
//        NavigationLink(state: LevelsFeature.Path.State.showGameResult(ResultFeature.State(finishedLevel: store.level)))
//        {
//            Text("Finish game")
//            .navigationTitle(Text(store.level.title))
//        }
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
                
                Rectangle()
                    .foregroundStyle(Color.init(red: 234 / 255.0, green: 227 / 255.0, blue: 217 / 255.0))
                    .aspectRatio(1, contentMode: .fit)
                
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
    GameView(store: Store(initialState: GameFeature.State(level: .init(title: "8"))) {
        GameFeature()
    })
}
