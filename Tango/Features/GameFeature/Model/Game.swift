//
//  Game.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

struct Game {

    let level: Level
    var gameCells: [[GameCell]]
    var gameConditions: [GameCellCondition] {
        level.gameConditions
    }

    init(_ level: Level) {
        self.level = level
        gameCells = level.gameCells
    }

    func isRowValid(_ row: Int) -> Bool {
        let rowArray = gameCells[row]
        let conditions = gameConditions.filter { $0.cellA.0 == row && $0.cellB.0 == row}
        return isCellsArrayValid(rowArray, conditions)
    }

    func isColumnValid(_ column: Int) -> Bool {
        let columnArray = gameCells.map { $0[column] }
        let conditions = gameConditions
            .filter { $0.cellA.1 == column && $0.cellB.1 == column}
            .map { GameCellCondition(condition: $0.condition, cellA: ($0.cellA.1, $0.cellA.0), cellB: ($0.cellB.1, $0.cellB.0)) }
        return isCellsArrayValid(columnArray, conditions)
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

    private func isCellsArrayValid(_ cells: [GameCell], _ conditions: [GameCellCondition]) -> Bool {
        let zeroes = cells.count { $0.value == 0 }
        let ones = cells.count { $0.value == 1 }

        // count of 0 and 1
        guard
            zeroes <= 3,
            ones <= 3
        else {
            return false
        }

        // no more than 2 after each other
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

        // check conditions
        for condition in conditions {
            let cellA = cells[condition.cellA.1]
            let cellB = cells[condition.cellB.1]
            guard cellA.value != nil && cellB.value != nil else { continue }

            if condition.condition == .equal && cellA.value != cellB.value {
                return false
            }

            if condition.condition == .opposite && cellA.value == cellB.value {
                return false
            }
        }

        return true
    }
}
