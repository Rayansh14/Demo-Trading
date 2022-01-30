//
//  SearchBar.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 16/05/21.
//

import SwiftUI

struct SearchBar: View {
    
    var placeholderText: String
    @Binding var searchText: String
    @Binding var isEditing: Bool
    @Binding var showSheet: Bool
    @Binding var sheetOffset: CGFloat
    @FocusState var isFocused
    
    var body: some View {
            HStack {
                
                TextField(placeholderText, text: $searchText)
                    .focused($isFocused)
                    .autocapitalization(.allCharacters)
                    .disableAutocorrection(true)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isEditing {
                                Button(action: {
                                    self.searchText = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                        self.showSheet = false
                        self.sheetOffset = 750
                        
                    }
                
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.searchText = ""
                        isFocused = false
                        
                    }) {
                            Text("Done")
                                .padding(5)
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default, value: isEditing)
                }
                
            }
            .animation(.easeInOut(duration: 0.5), value: isEditing)
            .if({
                !UIDevice.current.hasNotch
            }()) { view in
                view.padding(.top, 20)
            }
        }
}

extension UIDevice {
    var hasNotch: Bool {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return keyWindow?.safeAreaInsets.bottom ?? 0 > 0
    }
    
}
