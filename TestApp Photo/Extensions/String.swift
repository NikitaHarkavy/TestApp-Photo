//
//  String.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import Foundation

extension String {
    static func randomProjectName(existingProjectName: inout [String:Int]) -> String {
        let words = ["Sunset","Mountain","Beach","Forest","City","Portrait","Horizon","Sky","Ocean","Garden"]
        let base = words.randomElement()!.lowercased()
        let count = (existingProjectName[base] ?? 0) + 1
        existingProjectName[base] = count
        return "\(base)-\(count)"
    }
}
