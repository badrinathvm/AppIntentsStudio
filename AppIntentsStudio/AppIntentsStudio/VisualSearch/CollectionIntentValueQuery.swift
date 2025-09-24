//
//  CollectionIntentValueQuery.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

#if canImport(VisualIntelligence)
import AppIntents
import VideoToolbox
import VisualIntelligence

@UnionValue
enum VisualSearchResult {
    case collection(CollectionEntity)
}

struct CollectionIntentValueQuery: IntentValueQuery {
    @Dependency var modelData: ModelData
    
    func values(for input: SemanticContentDescriptor) async throws -> [VisualSearchResult] {
        guard let pixelBuffer: CVReadOnlyPixelBuffer = input.pixelBuffer else {
            return []
        }
        
        let results = try await modelData.search(matching: pixelBuffer)
        return results
    }
}

extension ModelData {
    
    func search(matching: CVReadOnlyPixelBuffer) throws -> [VisualSearchResult] {
        let results = collectionEntities.map { VisualSearchResult.collection($0) }
        return results
    }
}

#endif
