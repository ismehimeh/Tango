//
//  Level.swift
//  Tango
//
//  Created by Sergei Vasilenko on 14.03.2025.
//

import Foundation

struct Level: Identifiable {
    let id = UUID()
    let title: String // TODO: I am not planning to use it, just need it to distinguish cell for now
    let gameCells: [[GameCell]]
    let gameConditions: [GameCellCondition]
}
