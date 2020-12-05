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

final class JobsContainer: ObservableObject {
    @Published var jobs: [JobItem] = []
    @Published var isPending = true

    init(promise: Promise<[JobItem]>) {
        promise.done {
            self.isPending = false
            self.jobs = $0
        }.cauterize()
    }
}

struct JobBoardView: FlowableView {
    typealias Input = Promise<[JobItem]>
    typealias Output = JobBoardViewResponse

    public let resolver: Resolver<Output>

    @State private var searchText: String = ""
    @ObservedObject var jobsContainer: JobsContainer

    init(context: Input, resolver: Resolver<Output>) {
        self.resolver = resolver
        self.jobsContainer = JobsContainer(promise: context)
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 10)
                HStack {
                    TextField(L10n.Placeholder.search, text: $searchText)
                        .padding(10)
                        .background(Color.lightGrey)
                        .cornerRadius(5)
                        .padding(.horizontal, 10)
         
                    Button(L10n.Action.search, action: self.onSearch)
                        .padding(.trailing, 10)
                        .foregroundColor(Color.beehiveBrand)
                }
                List(self.jobsContainer.jobs) { jobItem in
                    JobRow(job: jobItem)
                        .onTapGesture {
                            self.onSelect(jobItem)
                        }
                }
                Spacer()
            }

            if self.jobsContainer.isPending {
                LoadingView()
                    .frame(width: 130.0, height: 100.0, alignment: .center)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(L10n.Title.brandName).font(.headline)
                    Text(L10n.Title.brandSlogan).font(.subheadline).foregroundColor(Color.white)
                }
            }
        }
    }
    
    private func onSelect(_ job: JobItem) {
        self.resolve(.select(job: job))
    }

    private func onSearch() {
        self.jobsContainer.isPending = true
        self.resolve(.search(term: self.searchText))
    }

}
