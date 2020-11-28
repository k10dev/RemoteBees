//
//  JobBoardFlowController.swift
//  RemoteBees
//

import UIKit
import PromiseKit
import FlowKit
import RemoteBeesFlow

class JobBoardFlowController: ViewCache, NavStateMachine, JobBoardStateMachine {
    var nav: UINavigationController!

    func onBegin(state: JobBoardState, context: Void) -> Promise<JobBoardState.Begin> {
        return Promise.value(.main(()))
    }

    func onMain(state: JobBoardState, context: Void) -> Promise<JobBoardState.Main> {
        return self.subflow(to: JobBoardView.self, context: context)
                   .map { .end(()) }
    }

    func onLogin(state: JobBoardState, context: Void) -> Promise<JobBoardState.Login> {
        return self.subflow(to: LoginFlowController(), context: context)
                   .map { .main(()) }
                   .back { .main(()) }
                   .cancel { .main(()) }
    }

    func onProfile(state: JobBoardState, context: Void) -> Promise<JobBoardState.Profile> {
        // TODO
        return Promise(error: FlowError.canceled)
    }

}
