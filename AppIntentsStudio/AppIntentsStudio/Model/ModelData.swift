//
//  ModelData.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

import Foundation

@Observable @MainActor
class ModelData {
    var collections: [Collection] = []
    var featuredCollection: Collection?
    var collectionById: [Int: Collection] = [:]
    
    init() {
        loadCollection()
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
