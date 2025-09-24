//
//  Collection.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

import Foundation

@Observable
class Collection: Codable, Identifiable, Sendable {
    var id: Int
    var name: String
    var description: String
    var rating: Double
    
    init(id: Int, name: String, description: String, rating: Double = 4) {
        self.id = id
        self.name = name
        self.description = description
        self.rating = rating
    }
    
    var thumbnailImage: String {
        "collection-\(id)"
    }
}


extension Collection {
    static let mockCollections: [Collection] = [
        Collection(
            id: 1,
            name: "Coffee Adventures",
            description: "A curated journey through the world's finest coffee beans, from Ethiopian highlands to Colombian mountains.",
            rating: 4.8
        ),
        
        Collection(
            id: 2,
            name: "Minimalist Living",
            description: "Essential items and practices for a clutter-free, intentional lifestyle that focuses on what truly matters.",
            rating: 4.7
        ),
        
        Collection(
            id: 3,
            name: "Night Sky Photography",
            description: "Stunning astrophotography locations, techniques, and gear recommendations for capturing the cosmos.",
            rating: 4.9
        ),
        
        Collection(
            id: 4,
            name: "Urban Sketching Spots",
            description: "Hidden gems and iconic locations perfect for architectural sketching and street art in major cities.",
            rating: 4.3
        ),
        
        Collection(
            id: 5,
            name: "Sourdough Mastery",
            description: "From starter cultivation to artisan bread techniques, everything needed to master the ancient art of sourdough.",
            rating: 4.6
        ),
        
        Collection(
            id: 6,
            name: "Vintage Vinyl Gems",
            description: "Rare and collectible records spanning jazz, rock, and soul from the golden era of analog music.",
            rating: 4.4
        ),
        
        Collection(
            id: 7,
            name: "Houseplant Paradise",
            description: "Low-maintenance to exotic plants that transform any space into a green sanctuary.",
            rating: 4.5
        ),
        
        Collection(
            id: 8,
            name: "Digital Detox Tools",
            description: "Apps, techniques, and strategies to reclaim focus and reduce screen time in our hyper-connected world.",
            rating: 4.2
        ),
        
        Collection(
            id: 9,
            name: "Sunset Chasers",
            description: "Epic sunset viewing locations around the globe, complete with timing tips and photography advice.",
            rating: 4.8
        ),
        
        Collection(
            id: 10,
            name: "Artisan Cheese Guide",
            description: "Handcrafted cheeses from small producers, perfect for creating memorable tasting experiences.",
            rating: 4.6
        ),
        
        Collection(
            id: 11,
            name: "Morning Rituals",
            description: "Science-backed routines and practices to start each day with energy, clarity, and purpose.",
            rating: 4.7
        ),
        
        Collection(
            id: 12,
            name: "Cozy Reading Nooks",
            description: "Design inspiration and book recommendations for creating the perfect reading sanctuary at home.",
            rating: 4.1
        )
    ]
}
