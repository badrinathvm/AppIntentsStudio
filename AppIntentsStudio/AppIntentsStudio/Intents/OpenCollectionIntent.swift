//
//  OpenCollectionIntent.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

import AppIntents

struct OpenCollectionIntent: OpenIntent {
    static let title: LocalizedStringResource = "Open Collection"
    
    @Parameter(title: "Collection", requestValueDialog: "Which Collection?")
    var target: CollectionEntity
    
    @MainActor
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
