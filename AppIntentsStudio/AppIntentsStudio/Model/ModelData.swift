//
//  ModelData.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

import Foundation
import UIKit

@Observable @MainActor
class ModelData {
    var collections: [Collection] = []
    var featuredCollection: Collection?
    var collectionById: [Int: Collection] = [:]
    var lastVisualSearchImageId: String?
    
    init() {
        loadCollection()
        createImagesDirectoryIfNeeded()
        // Clean up old images on app launch
        cleanupOldImages()
    }
    
    private func loadCollection() {
        collections = Collection.mockCollections
        
        for collection in collections {
            collectionById[collection.id] = collection
        }
    }
    
    func collections(for categoryIds: [Int]) -> [Collection] {
        var collections: [Collection] = []
        for collectionId in categoryIds {
            if let collection = collectionById[collectionId] {
                collections.append(collection)
            }
        }
        return collections
    }
}

extension ModelData {
    var collectionEntities: [CollectionEntity] {
        collections.map { CollectionEntity(collection: $0, modelData: self) }
    }

    func topRatedCollection() -> [CollectionEntity] {
        collections
            .sorted { $0.rating > $1.rating }
            .prefix(5)
            .map { CollectionEntity(collection: $0, modelData: self) }
    }
}

// MARK: - Visual Search Image Management
extension ModelData {
    private var imagesDirectory: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("VisualSearchImages")
    }

    func createImagesDirectoryIfNeeded() {
        try? FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
    }

    func saveVisualSearchImage(_ image: UIImage) -> String? {
        createImagesDirectoryIfNeeded()

        let imageId = UUID().uuidString
        let filename = "visual_search_\(imageId).jpg"
        let url = imagesDirectory.appendingPathComponent(filename)

        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        try? data.write(to: url)

        return imageId
    }

    func getImageURL(for imageId: String) -> URL {
        let filename = "visual_search_\(imageId).jpg"
        return imagesDirectory.appendingPathComponent(filename)
    }

    func loadImage(for imageId: String) -> UIImage? {
        let url = getImageURL(for: imageId)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    func getImageId(from filename: String) -> String? {
        // Extract UUID from filename like "visual_search_ABC123.jpg"
        let prefix = "visual_search_"
        let suffix = ".jpg"

        guard filename.hasPrefix(prefix) && filename.hasSuffix(suffix) else { return nil }

        let startIndex = filename.index(filename.startIndex, offsetBy: prefix.count)
        let endIndex = filename.index(filename.endIndex, offsetBy: -suffix.count)

        return String(filename[startIndex..<endIndex])
    }

    func cleanupOldImages() {
        guard let files = try? FileManager.default.contentsOfDirectory(at: imagesDirectory, includingPropertiesForKeys: [.creationDateKey]) else { return }

        let dayAgo = Date().addingTimeInterval(-24 * 60 * 60)

        for file in files {
            if let creationDate = try? file.resourceValues(forKeys: [.creationDateKey]).creationDate,
               creationDate < dayAgo {
                try? FileManager.default.removeItem(at: file)
            }
        }
    }

    func getMostRecentImage() -> (image: UIImage, imageId: String, createdAt: Date)? {
        guard let files = try? FileManager.default.contentsOfDirectory(at: imagesDirectory, includingPropertiesForKeys: [.creationDateKey]) else { return nil }

        let sortedFiles = files.compactMap { url -> (url: URL, imageId: String, date: Date)? in
            guard let creationDate = try? url.resourceValues(forKeys: [.creationDateKey]).creationDate,
                  let imageId = getImageId(from: url.lastPathComponent) else { return nil }
            return (url, imageId, creationDate)
        }.sorted { $0.date > $1.date }

        guard let mostRecent = sortedFiles.first,
              let data = try? Data(contentsOf: mostRecent.url),
              let image = UIImage(data: data) else { return nil }

        return (image, mostRecent.imageId, mostRecent.date)
    }

    func getAllVisualSearchImages() -> [(image: UIImage, imageId: String, createdAt: Date)] {
        guard let files = try? FileManager.default.contentsOfDirectory(at: imagesDirectory, includingPropertiesForKeys: [.creationDateKey]) else { return [] }

        return files.compactMap { url -> (image: UIImage, imageId: String, createdAt: Date)? in
            guard let creationDate = try? url.resourceValues(forKeys: [.creationDateKey]).creationDate,
                  let imageId = getImageId(from: url.lastPathComponent),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return nil }
            return (image, imageId, creationDate)
        }.sorted { $0.createdAt > $1.createdAt }
    }

    func clearAllVisualSearchImages() {
        guard let files = try? FileManager.default.contentsOfDirectory(at: imagesDirectory, includingPropertiesForKeys: nil) else { return }

        for file in files {
            try? FileManager.default.removeItem(at: file)
        }
    }
}
