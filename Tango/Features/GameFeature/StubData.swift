//
//  StubData.swift
//  Tango
//
//  Created by Sergei Vasilenko on 10.03.2025.
//

let level1: [[GameCell]] = [
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
