//
//  HomeView.swift
//  TestApp Photo
//
//  Created by Никита Горьковой on 29.07.25.
//

import SwiftUI
import PhotosUI
import UIKit

struct HomeView: View {
    @EnvironmentObject var vm: HomeViewModel
    @Environment(\.modelContext) var context
    
    @State private var selection: PhotosPickerItem?
    @State private var uiImage: UIImage?
    @State private var searchText = ""
    @State private var isShowingPhotoPicker = false
    
    private var filteredItems: [PhotoItem] {
        if searchText.isEmpty {
            return vm.items
        } else {
            return vm.items.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    isShowingPhotoPicker = true
                } label: {
                    Image("HomeNewImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                
                Spacer()
                
                Text("Projects")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button { } label: {
                    Image("HomeNewImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .opacity(0)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            HStack {
                Spacer().frame(width: 8)
                Image("HomeSearch")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                TextField("", text: $searchText, prompt: Text("Search")
                    .foregroundColor(.editing))
                .font(.system(size: 17))
                .fontWeight(.regular)
                .frame(height: 36.0)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.white)
                .submitLabel(.done)
                .onSubmit {
                    hideKeyboard()
                }
            }
            .background(Color.textField)
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer().frame(height: 8)
            
            if vm.items.isEmpty {
                emptyState
            } else {
                MasonryGridView(items: filteredItems)
            }
        }
        .overlay {
            if vm.isShowingOverlay, let state = vm.overlayState {
                EditingOverlayView(state: state) {
                    vm.dismissOverlay()
                }
            }
        }
        .photosPicker(
            isPresented: $isShowingPhotoPicker,
            selection: $selection,
            matching: .images
        )
        .onChange(of: selection) { new in
            guard let new = new else { return }
            new.loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async {
                    if case let .success(data?) = result, let img = UIImage(data: data) {
                        vm.processPicked(img)
                    } else {
                        print("Failed to load image")
                    }
                    selection = nil
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 0) {
            Image("HomeEmpty")
                .resizable()
                .scaledToFit()
                .frame(width: 54, height: 54)
            
            Spacer().frame(height: 12)
            
            Text("No projects yet")
                .font(.system(size: 19))
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Spacer().frame(height: 6)
            
            Text("Start editing your photos now")
                .font(.system(size: 13))
                .fontWeight(.regular)
                .foregroundColor(.editing)
            
            Spacer().frame(height: 20)
            
            Button("Start editing") {
                isShowingPhotoPicker = true
            }
            .frame(width: 224.0, height: 46.0)
            .background(Color.accentColor)
            .foregroundColor(.black)
            .cornerRadius(23)
            .font(.system(size: 13, weight: .regular))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(y: -50)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel(storage: PhotoStorageService()))
        .preferredColorScheme(.dark)
}
