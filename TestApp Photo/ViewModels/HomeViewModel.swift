//
//  HomeViewModel.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import SwiftUI
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var items: [PhotoItem] = []
    @Published var isShowingOverlay = false
    @Published var overlayState: OverlayState?
    
    private var nameCounters: [String:Int] = [:]
    private let storage: PhotoStorageService
    
    init(storage: PhotoStorageService) {
        self.storage = storage
        reload()
    }
    
    func reload() { items = storage.fetchAll() }
    
    func pickImage() {
        // handled by ProjectsView через PhotosPicker
    }
    
    func processPicked(_ uiImage: UIImage) {
        let name = String.randomProjectName(existingProjectName: &nameCounters)
        DispatchQueue.main.async {
            self.isShowingOverlay = true
            self.overlayState = .loading(name: name, imageSize: uiImage.size)
        }
        
        VisionService.shared.detectFaces(in: uiImage) { [weak self] faceDetected in
            guard let self = self else { return }
            
            let orientation = uiImage.aspectOrientation()
            guard let data = uiImage.jpegData(compressionQuality: 0.9) else {
                DispatchQueue.main.async {
                    self.overlayState = .error("Failed to process image")
                }
                return
            }
            
            let item = PhotoItem(name: name, imageData: data, faceDetected: faceDetected, orientation: orientation)
            
            do {
                try self.storage.savePhoto(item)
                DispatchQueue.main.async {
                    self.overlayState = .processed(item)
                    self.reload()
                }
            } catch {
                DispatchQueue.main.async {
                    self.overlayState = .error("Failed to save image")
                }
            }
        }
    }
    
    func dismissOverlay() {
        withAnimation(.easeInOut(duration: 0.3)) { isShowingOverlay = false }
    }
    
    func showOverlay(for item: PhotoItem) {
        overlayState = .processed(item)
        withAnimation(.easeInOut(duration: 0.3)) { isShowingOverlay = true }
    }
}

enum OverlayState: Equatable {
    case loading(name: String, imageSize: CGSize)
    case processed(PhotoItem)
    case error(String)
    
    static func == (lhs: OverlayState, rhs: OverlayState) -> Bool {
        switch (lhs, rhs) {
        case (.loading(let lhsName, let lhsSize), .loading(let rhsName, let rhsSize)):
            return lhsName == rhsName && lhsSize == rhsSize
        case (.processed(let lhsItem), .processed(let rhsItem)):
            return lhsItem.name == rhsItem.name && lhsItem.faceDetected == rhsItem.faceDetected
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
