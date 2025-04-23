//
//  GameSettings.swift
//  Tango
//
//  Created by Sergei Vasilenko on 18.04.2025.
//

import Foundation

final class GameSettings: ObservableObject {
    static let shared = GameSettings()
    
    @Published var showClock: Bool {
        didSet { UserDefaults.standard.set(showClock, forKey: Self.showClockKey) }
    }
    @Published var autoCheck: Bool {
        didSet { UserDefaults.standard.set(autoCheck, forKey: Self.autoCheckKey) }
    }
    
    private static let showClockKey = "showClock"
    private static let autoCheckKey = "autoCheck"
    
    private init() {
        let showClockDefault = UserDefaults.standard.object(forKey: Self.showClockKey) as? Bool ?? true
        let autoCheckDefault = UserDefaults.standard.object(forKey: Self.autoCheckKey) as? Bool ?? true
        self.showClock = showClockDefault
        self.autoCheck = autoCheckDefault
    }
}
