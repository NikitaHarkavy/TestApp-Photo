//
//  ButtonStyle.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(width: CGFloat = 224, height: CGFloat = 46, cornerRadius: CGFloat = 12) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height)
            .background(Color.accentColor)
            .foregroundColor(.black)
            .cornerRadius(cornerRadius)
            .font(.system(size: 17, weight: .semibold))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
