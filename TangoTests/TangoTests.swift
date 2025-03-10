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

    @Test func row4SunIsInalid() {
        let game = Game(gameCells: [createRow(with: [0, 0, 0, 0, nil, nil])], gameConditions: [])
        #expect(game.isRowValid(0) == false)
    }
}


//let testLevel: [[GameCell]] = Array(repeating: Array(repeating: GameCell(), count: 6), count: 6)


func createRow(with values: [Int?]) -> [GameCell] {
    values.map { GameCell(value: $0) }
}
