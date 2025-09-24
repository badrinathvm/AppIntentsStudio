//
//  VisualSearchDetailView.swift
//  AppIntentsStudio
//
//  Created by Rani Badri on 9/24/25.
//

import SwiftUI

struct VisualSearchDetailView: View {
    @Environment(ModelData.self) private var modelData
    let imageId: String
    @State private var image: UIImage?
    @State private var createdAt: Date?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    if let image = image {
                        ScrollView([.horizontal, .vertical]) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(
                                    maxWidth: geometry.size.width,
                                    maxHeight: geometry.size.height - geometry.safeAreaInsets.top - geometry.safeAreaInsets.bottom - 100
                                )
                                .pinchToZoom()
                        }
                        .navigationTitle("Visual Search")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Close") {
                                    dismiss()
                                }
                            }

                            ToolbarItem(placement: .navigationBarTrailing) {
                                Menu {
                                    if let createdAt = createdAt {
                                        Text("Captured: \(createdAt, formatter: dateFormatter)")
                                    }

                                    Divider()

                                    Button("Share Image") {
                                        shareImage()
                                    }

                                    Button("Delete Image", role: .destructive) {
                                        deleteImage()
                                    }
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                }
                            }
                        }
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "photo")
                                .font(.system(size: 64))
                                .foregroundColor(.secondary)

                            Text("Image Not Found")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            Button("Close") {
                                dismiss()
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        image = modelData.loadImage(for: imageId)

        // Try to get creation date from file metadata
        let url = modelData.getImageURL(for: imageId)
        createdAt = try? url.resourceValues(forKeys: [.creationDateKey]).creationDate
    }

    private func shareImage() {
        guard let image = image else { return }

        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }

    private func deleteImage() {
        let url = modelData.getImageURL(for: imageId)
        try? FileManager.default.removeItem(at: url)
        dismiss()
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

// Custom pinch-to-zoom modifier
extension View {
    func pinchToZoom() -> some View {
        self.scaleEffect(1.0)
            .gesture(
                MagnificationGesture()
                    .onChanged { scale in
                        // Handle zoom
                    }
            )
    }
}

#Preview {
    VisualSearchDetailView(imageId: "sample-id")
        .environment(ModelData())
}