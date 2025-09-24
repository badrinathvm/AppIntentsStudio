//
//  CollectionEntity.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

import Foundation
import AppIntents
import CoreSpotlight
import CoreTransferable
import SwiftUI

struct CollectionEntity: IndexedEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        return TypeDisplayRepresentation(name: LocalizedStringResource(
            "Collection",
            table: "AppIntentsStudio",
            comment: "The type name for the collection entity")
        )
    }
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)",
            subtitle: "\(subtitle)",
            image: .init(named: collection.thumbnailImage)
        )
    }

    static let defaultQuery = CollectionEntityQuery()
    
    var id: Int { collection.id }
    
    @ComputedProperty(indexingKey: \.displayName)
    var name: String { collection.name }
    
    @ComputedProperty(indexingKey: \.contentDescription)
    var description: String { collection.description }
    
    @ComputedProperty
    var subtitle: String { collection.description }
    
    var collection: Collection
    var modelData: ModelData
    
    init(collection: Collection, modelData: ModelData) {
        self.collection = collection
        self.modelData = modelData
    }
}

@MainActor
struct CollectionEntityQuery: EntityQuery, EntityStringQuery, EnumerableEntityQuery {
    @Dependency var modelData: ModelData
    
    func suggestedEntities() async throws -> [CollectionEntity] {
        modelData.topRatedCollection()
    }
    
    func entities(for identifiers: [CollectionEntity.ID]) async throws -> [CollectionEntity]  {
        modelData
            .collections(for: identifiers)
            .map { CollectionEntity(collection: $0, modelData: modelData) }
    }
    
    func allEntities() async throws -> [CollectionEntity] {
        modelData.collectionEntities
    }
    
    func entities(matching: String) async throws -> [CollectionEntity] {
        modelData
            .collections
            .filter { $0.name.contains(matching) }
            .map { CollectionEntity(collection: $0, modelData: modelData) }
    }
}
