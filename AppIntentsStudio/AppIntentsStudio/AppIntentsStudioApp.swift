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
    @State private var selectedImageId: String?
    @State private var showingDetailView = false

    init() {
        let data = modelData
        AppDependencyManager.shared.add(dependency: data)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
                .onOpenURL { url in
                    handleDeepLink(url)
                }
                .sheet(isPresented: $showingDetailView) {
                    if let imageId = selectedImageId {
                        VisualSearchDetailView(imageId: imageId)
                            .environment(modelData)
                    }
                }
        }
    }

    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "studio" else { return }

        switch url.host {
        case "visualsearch":
            let imageId = url.lastPathComponent
            selectedImageId = imageId
            showingDetailView = true

        case "collection":
            let collectionId = url.lastPathComponent
            // Handle collection deep link if needed
            print("Opening collection: \(collectionId)")

        default:
            break
        }
    }
}
