//
//  TangoTests.swift
//  TangoTests
//
//  Created by Sergei Vasilenko on 3.03.2025.
//

import Testing
@testable import Tango

struct TangoTests {
    
    func createTestLevel(cells: [[GameCell]], conditions: [GameCellCondition] = []) -> Level {
        Level(title: "1", gameCells: cells, gameConditions: conditions)
    }

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

    @Test func emptyRowValid() {
        let level = createTestLevel(cells: [Array(repeating: GameCell(), count: 6)])
        let game = Game(level)
        #expect(game.isRowValid(0) == true)
    }

    @Test func rowFullOfSunsIsInvalid() {
        let level = createTestLevel(cells: [Array(repeating: GameCell(value: 0), count: 6)])
        let game = Game(level)
        #expect(game.isRowValid(0) == false)
    }

    @Test func rowFullOfMoonsIsInvalid() {
        let level = createTestLevel(cells: [Array(repeating: GameCell(value: 1), count: 6)])
        let game = Game(level)
        #expect(game.isRowValid(0) == false)
    }

    @Test func row4Suns2MoonsIsInvalid() {
        let cells = [createRow(with: [1, 1, 0, 0, 0, 0])]
        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isRowValid(0) == false)
    }

    @Test func row2Suns4MoonsIsInvalid() {
        let cells = [createRow(with: [0, 0, 1, 1, 1, 1])]
        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isRowValid(0) == false)
    }

    @Test func row3Suns3MoonsIsInvalid() {
        let cells = [createRow(with: [0, 0, 0, 1, 1, 1])]
        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isRowValid(0) == false)
    }

    @Test func row1SunIsValid() {
        let cells = [createRow(with: [0, nil, nil, nil, nil, nil])]
        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isRowValid(0) == true)
    }

    @Test func row4SunIsInvalid() {
        let cells = [createRow(with: [0, 0, 0, 0, nil, nil])]
        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isRowValid(0) == false)
    }

    @Test func row4MoonsIsInvalid() {
        let cells = [createRow(with: [1, 1, 1, 1, nil, nil])]
        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isRowValid(0) == false)
    }

    @Test func row3MoonsIsInvalid() {
        let cells = [createRow(with: [1, 1, 1, nil, nil, nil])]
        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isRowValid(0) == false)
    }

    @Test func columnsValidity() {
        let cells: [[GameCell]] = [createRow(with: [1, 1, 0, nil, nil, 1]),
                                   createRow(with: [1, 1, 0, nil, nil, 1]),
                                   createRow(with: [1, 0, 1, nil, nil, 1]),
                                   createRow(with: [0, 0, 1, nil, nil, 1]),
                                   createRow(with: [0, 0, 1, nil, nil, 1]),
                                   createRow(with: [0, 0, 1, nil, 1, 1])]

        let level = createTestLevel(cells: cells)
        let game = Game(level)

        #expect(game.isColumnValid(0) == false)
        #expect(game.isColumnValid(1) == false)
        #expect(game.isColumnValid(2) == false)
        #expect(game.isColumnValid(3) == true)
        #expect(game.isColumnValid(4) == true)
        #expect(game.isColumnValid(5) == false)
    }

    @Test func emptyFieldIsValid() {
        let cells: [[GameCell]] = [createRow(with: [nil, nil, nil, nil, nil, nil]),
                                   createRow(with: [nil, nil, nil, nil, nil, nil]),
                                   createRow(with: [nil, nil, nil, nil, nil, nil]),
                                   createRow(with: [nil, nil, nil, nil, nil, nil]),
                                   createRow(with: [nil, nil, nil, nil, nil, nil]),
                                   createRow(with: [nil, nil, nil, nil, nil, nil])]

        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isFieldValid() == true)
    }

    @Test func sunFieldIsInvalid() {
        let cells: [[GameCell]] = [createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0])]

        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isFieldValid() == false)
    }

    @Test func emptyFieldIsNotSolved() {
        let cells: [[GameCell]] = [createRow(with: [nil, nil, nil, nil, nil, nil]),
                                   createRow(with: [nil, nil, nil, nil, nil, nil]),
                                   createRow(with: [nil, nil, nil, nil, nil, nil]),
                                   createRow(with: [nil, nil, nil, nil, nil, nil]),
                                   createRow(with: [nil, nil, nil, nil, nil, nil]),
                                   createRow(with: [nil, nil, nil, nil, nil, nil])]

        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isSolved() == false)
    }

    @Test func invalidFieldIsNotSolved() {
        let cells: [[GameCell]] = [createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0])]

        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isSolved() == false)
    }

    @Test func fieldIsSolved() {
        let cells: [[GameCell]] = [createRow(with: [1, 0, 0, 1, 1, 0]),
                                   createRow(with: [0, 1, 1, 0, 0, 1]),
                                   createRow(with: [1, 1, 0, 1, 0, 0]),
                                   createRow(with: [1, 0, 1, 0, 1, 0]),
                                   createRow(with: [0, 1, 0, 1, 0, 1]),
                                   createRow(with: [0, 0, 1, 0, 1, 1])]

        let level = createTestLevel(cells: cells)
        let game = Game(level)
        #expect(game.isSolved() == true)
    }

    @Test func invalidRowOfPredefinedValuesIsInvalid() {
        let cell = GameCell(predefinedValue: 0)
        let nilCell = GameCell(value: nil)
        let level = createTestLevel(cells: [[cell, cell, cell, nilCell, nilCell, nilCell]])
        let game = Game(level)
        #expect(game.isRowValid(0) == false)
    }

    @Test func twoSunsNilSunIsValid() {
        let predifinedCell = GameCell(predefinedValue: 0)
        let cell = GameCell(value: 0)
        let nilCell = GameCell(value: nil)
        let level = createTestLevel(cells: [[cell, cell, nilCell, predifinedCell, nilCell, nilCell]])
        let game = Game(level)
        #expect(game.isRowValid(0) == true)
    }

    @Test func rowWithViolatedXConditionIsInvalid() {
        let predifinedCell1 = GameCell(predefinedValue: 0)
        let nilCell = GameCell(value: nil)
        let condition = GameCellCondition(condition: .opposite, cellA: (0, 0), cellB: (0, 1))
        let level = createTestLevel(cells: [[predifinedCell1, predifinedCell1, nilCell, nilCell, nilCell]], conditions: [condition])
        let game = Game(level)
        #expect(game.isRowValid(0) == false)
    }

    @Test func rowWithViolatedEqualConditionIsInvalid() {
        let predifinedCell1 = GameCell(predefinedValue: 0)
        let predifinedCell2 = GameCell(predefinedValue: 1)
        let nilCell = GameCell(value: nil)
        let condition = GameCellCondition(condition: .equal, cellA: (0, 0), cellB: (0, 1))
        let level = createTestLevel(cells: [[predifinedCell1, predifinedCell2, nilCell, nilCell, nilCell]], conditions: [condition])
        let game = Game(level)
        #expect(game.isRowValid(0) == false)
    }

    @Test func rowWithNotViolatedXConditionIsValid() {
        let predifinedCell1 = GameCell(predefinedValue: 0)
        let predifinedCell2 = GameCell(predefinedValue: 1)
        let nilCell = GameCell(value: nil)
        let condition = GameCellCondition(condition: .opposite, cellA: (0, 0), cellB: (0, 1))
        let level = createTestLevel(cells: [[predifinedCell1, predifinedCell2, nilCell, nilCell, nilCell]], conditions: [condition])
        let game = Game(level)
        #expect(game.isRowValid(0) == true)
    }

    @Test func rowWithNotViolatedEqualConditionIsValid() {
        let predifinedCell1 = GameCell(predefinedValue: 0)
        let nilCell = GameCell(value: nil)
        let condition = GameCellCondition(condition: .equal, cellA: (0, 0), cellB: (0, 1))
        let level = createTestLevel(cells: [[predifinedCell1, predifinedCell1, nilCell, nilCell, nilCell]], conditions: [condition])
        let game = Game(level)
        #expect(game.isRowValid(0) == true)
    }
}

private extension TangoTests {
    func createRow(with values: [Int?]) -> [GameCell] {
        values.map { GameCell(value: $0) }
    }
}
