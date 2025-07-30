//
//  EditingOverlayView.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import SwiftUI
import UIKit

struct EditingOverlayView: View {
    let state: OverlayState
    let onDismiss: () -> Void
    @State private var isRotating = false
    private func makeTempURL(for item: PhotoItem) -> URL? {
        guard let image = UIImage(data: item.imageData),
              let data = image.jpegData(compressionQuality: 0.9)
        else { return nil }
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(item.name).jpg")
        try? data.write(to: url)
        return url
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                switch state {
                case .loading(let name, let imageSize):
                    VStack(spacing: 16) {
                        Rectangle()
                            .fill(Color.editing)
                            .aspectRatio(imageSize.width / imageSize.height, contentMode: .fit)
                            .frame(maxWidth: 300, maxHeight: 375)
                            .cornerRadius(12)
                        HStack {
                            Text(name)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                            Image("EditingActivity")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .rotationEffect(.degrees(isRotating ? 360 : 0))
                                .animation(
                                    isRotating ? 
                                        .linear(duration: 1).repeatForever(autoreverses: false) : 
                                        .default,
                                    value: isRotating
                                )
                        }
                        .padding(.horizontal, 24)
                    }
                    Spacer().frame(height: 46)
                case .processed(let item):
                    VStack(spacing: 16) {
                        if let image = UIImage(data: item.imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 300, maxHeight: 375)
                                .cornerRadius(12)
                        }
                        HStack {
                            Text(item.name)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                            Image(item.faceDetected ? "EditingPerson" : "EditingNoPerson")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        .padding(.horizontal, 24)
                    }
                case .error(let message):
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.red)
                        Text("Error")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(message)
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 24)
                }
                Spacer()
                if case .processed(let item) = state, let url = makeTempURL(for: item) {
                    ShareLink(item: url) {
                        Text("Export")
                            .font(.system(size: 13))
                            .fontWeight(.regular)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(Color.accentColor)
                            .cornerRadius(23)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            ))
        }
        .onTapGesture { onDismiss() }
        .onAppear {
            if case .loading = state {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isRotating = true
                }
            }
        }
        .onChange(of: state) { newState in
            switch newState {
            case .processed, .error:
                isRotating = false
            case .loading:
                isRotating = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            if case .loading = state {
                isRotating = true
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
    
    Group {
        EditingOverlayView(
            state: .processed(sampleItem),
            onDismiss: {}
        )
    }
    .preferredColorScheme(.dark)
}
