//
//  TangoTests.swift
//  TangoTests
//
//  Created by Sergei Vasilenko on 3.03.2025.
//

import Testing
@testable import Tango

struct TangoTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

    @Test func emptyRowValid() {
        let game = Game(gameCells: [Array(repeating: GameCell(), count: 6)], gameConditions: [])
        #expect(game.isRowValid(0) == true)
    }

    @Test func rowFullOfSunsIsInvalid() {
        let game = Game(gameCells: [Array(repeating: GameCell(value: 0), count: 6)], gameConditions: [])
        #expect(game.isRowValid(0) == false)
    }

    @Test func rowFullOfMoonsIsInvalid() {
        let game = Game(gameCells: [Array(repeating: GameCell(value: 1), count: 6)], gameConditions: [])
        #expect(game.isRowValid(0) == false)
    }

    @Test func row4Suns2MoonsIsInvalid() {
        let game = Game(gameCells: [createRow(with: [1, 1, 0, 0, 0, 0])], gameConditions: [])
        #expect(game.isRowValid(0) == false)
    }

    @Test func row2Suns4MoonsIsInvalid() {
        let game = Game(gameCells: [createRow(with: [0, 0, 1, 1, 1, 1])], gameConditions: [])
        #expect(game.isRowValid(0) == false)
    }

    @Test func row3Suns3MoonsIsValid() {
        let game = Game(gameCells: [createRow(with: [0, 0, 0, 1, 1, 1])], gameConditions: [])
        #expect(game.isRowValid(0) == true)
    }

    @Test func row1SunIsValid() {
        let game = Game(gameCells: [createRow(with: [0, nil, nil, nil, nil, nil])], gameConditions: [])
        #expect(game.isRowValid(0) == true)
    }

    @Test func row4SunIsInvalid() {
        let game = Game(gameCells: [createRow(with: [0, 0, 0, 0, nil, nil])], gameConditions: [])
        #expect(game.isRowValid(0) == false)
    }

    @Test func columnsValidity() {
        let cells: [[GameCell]] = [createRow(with: [1, 1, 0, nil, nil, 1]),
                                   createRow(with: [1, 1, 0, nil, nil, 1]),
                                   createRow(with: [1, 0, 1, nil, nil, 1]),
                                   createRow(with: [0, 0, 1, nil, nil, 1]),
                                   createRow(with: [0, 0, 1, nil, nil, 1]),
                                   createRow(with: [0, 0, 1, nil, 1, 1])]

        let game = Game(gameCells: cells, gameConditions: [])

        #expect(game.isColumnValid(0) == true)
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

        let game = Game(gameCells: cells, gameConditions: [])
        #expect(game.isFieldValid() == true)
    }

    @Test func sunFieldIsInvalid() {
        let cells: [[GameCell]] = [createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0]),
                                   createRow(with: [0, 0, 0, 0, 0, 0])]

        let game = Game(gameCells: cells, gameConditions: [])
        #expect(game.isFieldValid() == false)
    }

    // TODO: need more tests
}


//let testLevel: [[GameCell]] = Array(repeating: Array(repeating: GameCell(), count: 6), count: 6)


func createRow(with values: [Int?]) -> [GameCell] {
    values.map { GameCell(value: $0) }
}
