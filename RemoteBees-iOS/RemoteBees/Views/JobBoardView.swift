//
//  JobBoardView.swift
//  RemoteBees
//

import SwiftUI
import FlowKit
import PromiseKit
import RemoteBeesFlow

enum JobBoardViewResponse {
    case login
    case profile
    case search(term: String)
    case select(job: JobItem)
}

struct JobBoardView: FlowableView {
    typealias Input = Promise<[JobItem]>
    typealias Output = JobBoardViewResponse

    public let resolver: Resolver<Output>

    @State private var searchText: String = ""
    @State private var jobItems: [JobItem] = []
    @State private var isLoading = true

    private var context: Input

    init(context: Input, resolver: Resolver<Output>) {
        self.resolver = resolver
        self.context = context
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 10)
                JobSearchBar(text: $searchText)
                List(self.jobItems) { jobItem in
                    JobRow(job: jobItem)
                        .onTapGesture {
                            self.onSelect(jobItem)
                        }
                }
                Spacer()
            }
            .onAppear {
                self.context.done {
                    self.isLoading = false
                    self.jobItems = $0
                }.cauterize()
            }

            if self.isLoading {
                LoadingView()
                    .frame(width: 130.0, height: 100.0, alignment: .center)
            }
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
    
    private func onSelect(_ job: JobItem) {
        self.resolve(.select(job: job))
    }

}
