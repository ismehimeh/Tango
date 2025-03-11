//
//  GameCondition.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

import Foundation

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
