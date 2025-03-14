//
//  StubData.swift
//  Tango
//
//  Created by Sergei Vasilenko on 10.03.2025.
//

// MARK: - Level 1
let level1Cells: [[GameCell]] = [
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

let level1 = Level(title: "1", gameCells: level1Cells, gameConditions: level1Conditions)

// MARK:  - Level 2
let level2Cells: [[GameCell]] = [
    // 1
    [GameCell(), GameCell(), GameCell(), GameCell(), GameCell(), GameCell()],
    // 2
    [GameCell(), GameCell(predefinedValue: 1), GameCell(), GameCell(predefinedValue: 0), GameCell(predefinedValue: 1), GameCell()],
    // 3
    [GameCell(), GameCell(predefinedValue: 0), GameCell(), GameCell(), GameCell(), GameCell()],
    // 4
    [GameCell(), GameCell(), GameCell(), GameCell(), GameCell(predefinedValue: 0), GameCell()],
    // 5
    [GameCell(), GameCell(predefinedValue: 1), GameCell(predefinedValue: 0), GameCell(), GameCell(predefinedValue: 0), GameCell()],
    // 6
    [GameCell(), GameCell(), GameCell(), GameCell(), GameCell(), GameCell()],
]

let level2Conditions: [GameCellCondition] = [
    .init(condition: .equal, cellA: (0, 2), cellB: (0, 3)),
    .init(condition: .opposite, cellA: (0, 4), cellB: (0, 5)),
    .init(condition: .opposite, cellA: (1, 0), cellB: (2, 0)),
    .init(condition: .equal, cellA: (3, 5), cellB: (4, 5)),
    .init(condition: .equal, cellA: (5, 0), cellB: (5, 1)),
    .init(condition: .opposite, cellA: (5, 2), cellB: (5, 3)),
]

let level2 = Level(title: "2", gameCells: level2Cells, gameConditions: level2Conditions)
