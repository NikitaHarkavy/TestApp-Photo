//
//  UIImage.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import UIKit

extension UIImage {
    func aspectOrientation() -> PhotoOrientation {
        let w = size.width, h = size.height
        if w / h > 1.1 { return .landscape }
        if h / w > 1.1 { return .portrait }
        return .square
    }
}
