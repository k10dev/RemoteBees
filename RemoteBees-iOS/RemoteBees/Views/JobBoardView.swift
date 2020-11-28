//
//  JobBoardView.swift
//  RemoteBees
//

import SwiftUI
import FlowKit
import PromiseKit

struct JobBoardView: FlowableView {
    typealias Input = Void
    typealias Output = Void

    public let resolver: Resolver<Output>
    
    @State private var searchText: String = ""
    
    init(context: Void, resolver: Resolver<Output>) {
        self.resolver = resolver
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            JobSearchBar(text: $searchText)
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Remote Bees").font(.headline)
                    Text("Find Your Happiness").font(.subheadline).foregroundColor(Color.white)
                }
            }
        }
    }

}
