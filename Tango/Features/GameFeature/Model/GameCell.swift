//
//  GameCell.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

struct GameCell {
    let predefinedValue: Int?
    private var _value: Int?

    var value: Int? {
        get {
            predefinedValue ?? _value
        }

        set {
            _value = newValue
        }
    }

    init(predefinedValue: Int? = nil, value: Int? = nil) {
        self.predefinedValue = predefinedValue
        self._value = value
    }
}
