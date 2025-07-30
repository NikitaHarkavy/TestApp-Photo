//
//  TestApp_PhotoApp.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import SwiftUI
import SwiftData

@main
struct TestApp_PhotoApp: App {
    @StateObject private var storage: PhotoStorageService
    @StateObject private var projectsVM: HomeViewModel
    
    init() {
        let storage = PhotoStorageService()
        _storage = StateObject(wrappedValue: storage)
        _projectsVM = StateObject(wrappedValue: HomeViewModel(storage: storage))
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.modelContext, storage.container.mainContext)
                .environmentObject(projectsVM)
                .preferredColorScheme(.dark)
                .background(Color.back)
        }
    }
}
