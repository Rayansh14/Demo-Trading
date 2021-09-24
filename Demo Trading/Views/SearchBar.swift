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
    
    var body: some View {
        ZStack {
            HStack {
                
                if true {
                    TextField(placeholderText, text: $searchText)
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
                        }
                }
                
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.searchText = ""
                        dismissKeyboard()
                        
                    }) {
                        Text("Done")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
                
            }
            .animation(.easeInOut(duration: 0.5))
        }
    }
}