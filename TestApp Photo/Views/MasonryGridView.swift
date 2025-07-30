//
//  MasonryGridView.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import SwiftUI

struct MasonryGridView: View {
    let items: [PhotoItem]
    @EnvironmentObject private var vm: HomeViewModel
    
    let columns = 2
    let spacing: CGFloat = 12
    let horizontalPadding: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            let columnWidth = (geometry.size.width - horizontalPadding * 2 - spacing) / CGFloat(columns)
            
            ScrollView {
                HStack(alignment: .top, spacing: spacing) {
                    ForEach(0..<columns, id: \.self) { column in
                        LazyVStack(spacing: spacing) {
                                          ForEach(columnItems(for: column), id: \.id) { item in
                PhotoItemView(item: item)
                  .frame(width: columnWidth)
                  .id(item.id)
              }
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, spacing)
            }
        }
    }
    
    private func columnItems(for column: Int) -> [PhotoItem] {
        stride(from: column, to: items.count, by: columns).map { items[$0] }
    }
}

#Preview {
    let sampleData = UIImage(systemName: "photo")?.pngData() ?? Data()
    let sampleItems = [
        PhotoItem(name: "mountain-1", imageData: sampleData, faceDetected: false, orientation: .landscape),
        PhotoItem(name: "forest-1", imageData: sampleData, faceDetected: true, orientation: .portrait),
        PhotoItem(name: "garden-1", imageData: sampleData, faceDetected: false, orientation: .square),
        PhotoItem(name: "sunset-1", imageData: sampleData, faceDetected: true, orientation: .portrait),
        PhotoItem(name: "beach-1", imageData: sampleData, faceDetected: false, orientation: .landscape)
    ]
    
    MasonryGridView(items: sampleItems)
        .environmentObject(HomeViewModel(storage: PhotoStorageService()))
        .preferredColorScheme(.dark)
} 
