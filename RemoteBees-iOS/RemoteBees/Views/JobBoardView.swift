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
    
    init(context: Void, resolver: Resolver<Output>) {
        self.resolver = resolver
    }

    var body: some View {
        VStack {
            Text("Job Board")
        }
    }

}
