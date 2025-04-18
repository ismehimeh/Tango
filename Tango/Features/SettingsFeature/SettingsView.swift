//
//  SettingsView.swift
//  Tango
//
//  Created by Sergei Vasilenko on 18.04.2025.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    
    @Bindable var store: StoreOf<SettingsFeature>
    
    var body: some View {
        HStack {
            Label("Show clock", systemImage: "clock")
            Spacer()
            Toggle("", isOn: $store.isShowClockIsOn.sending(\.isShowClockIsOnChanged))
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
        
        HStack {
            Label("Auto-check", systemImage: "checkmark.seal.fill")
            Spacer()
            Toggle("", isOn: $store.isAutoCheckInOn.sending(\.isAutoCheckInOnChanged))
        }
        .padding(.horizontal, 20)
        
        Spacer()
    }
}

#Preview {
    let state = SettingsFeature.State()
    let store = Store(initialState: state) {
        SettingsFeature()
    }
    SettingsView(store: store)
}
