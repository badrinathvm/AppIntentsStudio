//
//  ContentView.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

import SwiftUI

struct ContentView: View {
    @State private var modelData = ModelData()

    var body: some View {
        TabView {
            VisualSearchResultView()
                .tabItem {
                    Image(systemName: "camera.viewfinder")
                    Text("Visual Search")
                }
                .environment(modelData)

            CollectionsView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Collections")
                }
                .environment(modelData)
        }
    }
}

struct CollectionsView: View {
    @Environment(ModelData.self) private var modelData

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(modelData.collections) { collection in
                        CollectionCard(collection: collection)
                    }
                }
                .padding()
            }
            .navigationTitle("Collections")
        }
    }
}

struct CollectionCard: View {
    let collection: Collection

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: collection.thumbnailImageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(collection.name)
                    .font(.headline)
                    .lineLimit(1)

                Text(collection.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text("\(collection.rating, specifier: "%.1f")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 4)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

#Preview {
    ContentView()
}
