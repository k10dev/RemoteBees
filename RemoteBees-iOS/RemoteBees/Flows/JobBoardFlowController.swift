/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import UIKit
import PromiseKit
import FlowKit
import RemoteBeesFlow
import SafariServices

class JobBoardFlowController: ViewCache, NavStateMachine, JobBoardStateMachine {
    var nav: UINavigationController!
    private var jobItems: [JobItem] = []

    func onBegin(state: JobBoardState, context: Void) -> Promise<JobBoardState.Begin> {
        return Promise.value(.main(self.getAllJobs()))
    }

    func onMain(state: JobBoardState, context: Promise<[JobItem]>) -> Promise<JobBoardState.Main> {
        return self.subflow(to: JobBoardView.self, context: context)
                   .map {
                        switch $0 {
                            case .profile:
                                return .profile(())
                            case .login:
                                return .login(())
                            case .search(let term):
                                return .search(term)
                            case .select(let job):
                                return .viewDetail(job)
                        }
                   }
    }

    func onLogin(state: JobBoardState, context: Void) -> Promise<JobBoardState.Login> {
        return self.subflow(to: LoginFlowController(), context: context)
                    .map { .main(.value(self.jobItems)) }
                    .back { .main(.value(self.jobItems)) }
                    .cancel { .main(.value(self.jobItems)) }
    }

    func onProfile(state: JobBoardState, context: Void) -> Promise<JobBoardState.Profile> {
        // TODO
        return Promise(error: FlowError.canceled)
    }

    func onSearch(state: JobBoardState, context: String) -> Promise<JobBoardState.Search> {
        guard !context.isEmpty else {
            return Promise.value(.main(self.getAllJobs()))
        }

        return AppProxy.proxy.serviceManager.beehiveService.searchJobs(by: .listing(context))
                        .map { jobs -> JobBoardState.Search in
                            let jobItems: [JobItem] = jobs.map { $0.toJobItem() }
                            self.jobItems = jobItems
                            return .main(.value(jobItems))
                        }
    }

    func onViewDetail(state: JobBoardState, context: JobItem) -> Promise<JobBoardState.ViewDetail> {
        guard let jobUrl = URL(string: context.url) else {
            return Promise.value(.main(.value(self.jobItems)))
        }

        return Promise { resolver in
            let safariVC = SFSafariViewController(url: jobUrl)
            self.nav.present(safariVC, animated: true) {
                resolver.fulfill(())
            }
        }
        .map {
            .main(.value(self.jobItems))
        }
    }

    private func getAllJobs() -> Promise<[JobItem]> {
        return AppProxy.proxy.serviceManager.beehiveService.getAllJobs()
                               .map { jobs -> [JobItem] in
                                    let jobItems: [JobItem] = jobs.map { $0.toJobItem() }
                                    self.jobItems = jobItems
                                    return jobItems
                               }
    }
}

extension Job {
    func toJobItem() -> JobItem {
        JobItem(id: self.id,
                url: self.url,
                title: self.title,
                companyName: self.companyName,
                category: self.category,
                publicationDate: self.publicationDate,
                salary: self.salary
        )
    }
}
