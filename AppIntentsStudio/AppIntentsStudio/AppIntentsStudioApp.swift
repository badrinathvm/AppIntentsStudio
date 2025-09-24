//
//  AppIntentsStudioApp.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

import AppIntents
import SwiftUI

@main
struct AppIntentsStudioApp: App {
    @State private var modelData = ModelData()
    
    init() {
        let data = modelData
        AppDependencyManager.shared.add(dependency: data)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
