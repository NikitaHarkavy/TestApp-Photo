//
//  PhotoItem.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import Foundation
import SwiftData

@Model
class PhotoItem {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var imageData: Data
    var faceDetected: Bool
    var orientation: PhotoOrientation
    
    init(name: String, imageData: Data, faceDetected: Bool, orientation: PhotoOrientation) {
        self.name = name
        self.imageData = imageData
        self.faceDetected = faceDetected
        self.orientation = orientation
    }
}
