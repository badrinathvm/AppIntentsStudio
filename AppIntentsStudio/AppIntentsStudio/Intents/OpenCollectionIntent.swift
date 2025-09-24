//
//  OpenCollectionIntent.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

import AppIntents
import UIKit

struct OpenCollectionIntent: OpenIntent {
    static let title: LocalizedStringResource = "Open Collection"

    @Parameter(title: "Collection", requestValueDialog: "Which Collection?")
    var target: CollectionEntity

    @MainActor
    func perform() async throws -> some IntentResult {
        // Check if this is from a visual search (use stored imageId)
        if let imageId = target.modelData.lastVisualSearchImageId {
            let deepLinkURL = "studio://visualsearch/\(imageId)"
            if let url = URL(string: deepLinkURL) {
                await UIApplication.shared.open(url)
            }
        } else {
            // Regular collection opening - could open to collection detail
            let collectionURL = "studio://collection/\(target.collection.id)"
            if let url = URL(string: collectionURL) {
                await UIApplication.shared.open(url)
            }
        }

        return .result()
    }
}
