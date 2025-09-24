//
//  IntentsStudioAppShortcuts.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

import AppIntents

struct IntentsStudioAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenCollectionIntent(),
            phrases: [
                "Open in \(.applicationName)",
            ],
            shortTitle: "Open",
            systemImageName: "building.columns"
        )
    }
}
