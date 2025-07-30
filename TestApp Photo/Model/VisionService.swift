//
//  VisionService.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import UIKit
import Vision

class VisionService {
    static let shared = VisionService()
    
    func detectFaces(in image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let cg = image.cgImage else {
            completion(false)
            return
        }
        let request = VNDetectFaceRectanglesRequest { req, _ in
            let found = (req.results?.isEmpty == false)
            DispatchQueue.main.async { completion(found) }
        }
        let handler = VNImageRequestHandler(cgImage: cg, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}
