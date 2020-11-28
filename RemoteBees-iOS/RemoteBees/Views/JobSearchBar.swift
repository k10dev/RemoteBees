//
//  SearchBar.swift
//  RemoteBees
//

import SwiftUI

struct JobSearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {

            TextField("Job title, keywords, or company", text: $text)
                .padding(10)
                .background(Color.lightGrey)
                .cornerRadius(5)
                .padding(.horizontal, 10)
//                .onTapGesture {
//                    self.isEditing = true
//                }
 
//            if isEditing {
                Button(action: {
//                    self.isEditing = false
                    self.text = ""
                }) {
                    Text("Search")
                }
                .padding(.trailing, 10)
                .foregroundColor(Color.beehiveBrand)
//            }
        }
    }
}
