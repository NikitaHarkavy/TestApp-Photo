//
//  PhotoItemView.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import SwiftUI
import UIKit

struct PhotoItemView: View {
    let item: PhotoItem
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: UIImage(data: item.imageData)!)
                .resizable()
                .scaledToFill()
                .frame(width: (UIScreen.main.bounds.width - 44) / 2, height: height(for: item.orientation))
            
            HStack(spacing: 8) {
                Text(item.name)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Spacer()
                Image(item.faceDetected ? "EditingPerson" : "EditingNoPerson")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.accentColor)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
        }
        .frame(width: (UIScreen.main.bounds.width - 44) / 2, height: height(for: item.orientation))
        .cornerRadius(12)
        .onTapGesture {
            vm.showOverlay(for: item)
        }
    }
    
    private func height(for orientation: PhotoOrientation) -> CGFloat {
        guard let image = UIImage(data: item.imageData) else {
            switch orientation {
            case .portrait:  return 236
            case .square:    return 177
            case .landscape: return 140
            }
        }
        let columnWidth = (UIScreen.main.bounds.width - 44) / 2
        let aspectRatio = image.size.height / image.size.width
        
        if aspectRatio >= 3.0 {
            return 260
        }
        else if abs(aspectRatio - 1.0) < 0.1 {
            return columnWidth
        }
        else if aspectRatio > 1.0 {
            let progress = (aspectRatio - 1.0) / 2.0
            return columnWidth + (260 - columnWidth) * progress
        }
        else {
            if aspectRatio < 0.5 {
                return 140
            }
            else {
                let progress = (aspectRatio - 0.5) / (1.0 - 0.5)
                return 140 + (columnWidth - 140) * progress
            }
        }
    }
}

#Preview {
    let sampleData = UIImage(systemName: "photo")?.pngData() ?? Data()
    let sampleItem = PhotoItem(
        name: "sample-photo",
        imageData: sampleData,
        faceDetected: true,
        orientation: .portrait
    )
    
    PhotoItemView(item: sampleItem)
        .environmentObject(HomeViewModel(storage: PhotoStorageService()))
        .frame(width: 200)
        .preferredColorScheme(.dark)
}
