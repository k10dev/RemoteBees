/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import UIKit
import PromiseKit
import FlowKit
import RemoteBeesFlow
import Logging

class StartupFlowController: ViewCache, NavStateMachine, StartupStateMachine {
    var nav: UINavigationController!

    private lazy var logger = Logger(label: "dev.beehive.RemoteBees/StartupFlow")

    func onBegin(state: StartupState, context: Void) -> Promise<StartupState.Begin> {
        return Promise.value(.entry(context))
    }

    func onEntry(state: StartupState, context: Void) -> Promise<StartupState.Entry> {
        var preferences = UserDefaults.preferences()
        if preferences.firstTimeUsed {
            preferences.firstTimeUsed = false
            return .value(.onboard(context))
        } else {
            return .value(.jobBoard(context))
        }
    }

    func onOnboard(state: StartupState, context: Void) -> Promise<StartupState.Onboard> {
        return self.subflow(to: OnboardFlowController(), context: context)
                   .map { .jobBoard(()) }
    }

    func onJobBoard(state: StartupState, context: Void) -> Promise<StartupState.JobBoard> {
        return self.subflow(to: JobBoardFlowController(), context: context)
                   .map { .end(()) }
    }

}
