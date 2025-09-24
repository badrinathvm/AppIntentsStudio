//
//  VisualSearchResultView.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

import SwiftUI

struct VisualSearchResultView: View {
    @Environment(ModelData.self) private var modelData
    @State private var recentImage: UIImage?
    @State private var recentImageId: String?
    @State private var searchTime: Date?
    @State private var showingDetailView = false

    var body: some View {
        VStack(spacing: 16) {
            if let image = recentImage, let time = searchTime {
                VStack(spacing: 12) {
                    Text("Visual Intelligence Search")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text("Captured: \(time, formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 4)
                        .onTapGesture {
                            showingDetailView = true
                        }

                    HStack {
                        Button("Clear Image") {
                            clearRecentImage()
                        }
                        .foregroundColor(.red)

                        Spacer()

                        Button("Clear All") {
                            modelData.clearAllVisualSearchImages()
                            clearRecentImage()
                        }
                        .foregroundColor(.orange)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 2)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)

                    Text("No Recent Visual Search")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text("Use Visual Intelligence to search for collections and they'll appear here.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            loadRecentImage()
        }
        .refreshable {
            loadRecentImage()
        }
        .sheet(isPresented: $showingDetailView) {
            if let imageId = recentImageId {
                VisualSearchDetailView(imageId: imageId)
                    .environment(modelData)
            }
        }
    }

    private func loadRecentImage() {
        guard let result = modelData.getMostRecentImage() else {
            recentImage = nil
            recentImageId = nil
            searchTime = nil
            return
        }

        recentImage = result.image
        recentImageId = result.imageId
        searchTime = result.createdAt
    }

    private func clearRecentImage() {
        recentImage = nil
        recentImageId = nil
        searchTime = nil
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    VisualSearchResultView()
        .environment(ModelData())
}
