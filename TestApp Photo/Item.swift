//
//  Item.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
