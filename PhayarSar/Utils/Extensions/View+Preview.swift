//
//  View+Preview.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 30/12/2023.
//

import SwiftUI

@MainActor extension View {
    func previewEnvironment() -> some View {
        self
            .environmentObject(UserPreferences())
            .environment(\.managedObjectContext, CoreDataStack.shared.viewContext)
    }
}
