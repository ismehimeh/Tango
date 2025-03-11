//
//  Game.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

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
