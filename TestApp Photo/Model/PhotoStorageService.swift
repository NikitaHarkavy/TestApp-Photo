//
//  PhotoStorageService.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import Foundation
import SwiftData

@MainActor
class PhotoStorageService: ObservableObject {
    let container: ModelContainer
    
    init() {
        container = try! ModelContainer(for: PhotoItem.self)
    }
    
    func savePhoto(_ item: PhotoItem) throws {
        container.mainContext.insert(item)
        try container.mainContext.save()
    }
    
    func fetchAll() -> [PhotoItem] {
        let req = FetchDescriptor<PhotoItem>()
        do {
            return try container.mainContext.fetch(req)
        } catch {
            print("Failed to fetch photos: \(error)")
            return []
        }
    }
}
