//
//  ConditionView.swift
//  Tango
//
//  Created by Sergei Vasilenko on 10.03.2025.
//

import SwiftUI

struct ConditionView: View {
    let condition: GameCellCondition.Condition

    var body: some View {
        Circle()
            .frame(width: 20, height: 20)
            .foregroundStyle(.white)
            .overlay {
                switch condition {
                case .equal:
                    Image(systemName: "equal")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color(red: 135 / 255.0, green: 114 / 255.0, blue: 85 / 255.0))
                case .opposite:
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color(red: 135 / 255.0, green: 114 / 255.0, blue: 85 / 255.0))
                }
            }
    }
}

#Preview {
    ConditionView(condition: .equal)
}
