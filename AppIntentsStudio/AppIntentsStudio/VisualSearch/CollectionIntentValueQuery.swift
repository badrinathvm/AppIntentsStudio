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
import UIKit

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

        // Save the captured image to file system
        var savedImageId: String?
        if let image = getImage(from: pixelBuffer) {
            savedImageId = await modelData.saveVisualSearchImage(image)
        }

        let results = try await modelData.search(matching: pixelBuffer, imageId: savedImageId)
        return results
    }
    
    private func getImage(from pixelBuffer: CVReadOnlyPixelBuffer) -> UIImage? {
        pixelBuffer.withUnsafeBuffer { cvPixelBuffer in
            
            let ciImage = CIImage(cvPixelBuffer: cvPixelBuffer)
            
            let context = CIContext()
            
            guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
            
            return UIImage(cgImage: cgImage)
        }
    }
}

extension ModelData {

    func search(matching: CVReadOnlyPixelBuffer, imageId: String?) throws -> [VisualSearchResult] {
        // Store the imageId for later use in OpenCollectionIntent
        lastVisualSearchImageId = imageId

        // Return original collection entities (imageId will be accessed via ModelData)
        let results = collectionEntities.map { VisualSearchResult.collection($0) }
        return results
    }
}

#endif
