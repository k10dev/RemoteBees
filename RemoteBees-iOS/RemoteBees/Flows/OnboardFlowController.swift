//
//  OnboardFlowController.swift
//  RemoteBees
//

import UIKit
import PromiseKit
import FlowKit
import RemoteBeesFlow
import Logging

class OnboardFlowController: ViewCache, NavStateMachine, OnboardStateMachine {
    var nav: UINavigationController!

    func onBegin(state: OnboardState, context: Void) -> Promise<OnboardState.Begin> {
        return Promise.value(.prompt(context))
    }

    func onPrompt(state: OnboardState, context: Void) -> Promise<OnboardState.Prompt> {
        return self.subflow(to: OnboardView.self, context: context)
                    .map {
                        switch $0 {
                            case .login:
                                return .login(context)
                            case .signup:
                                return .signUp(context)
                            case .skip:
                                return .skip(context)
                        }
                    }
    }
    
    func onLogin(state: OnboardState, context: Void) -> Promise<OnboardState.Login> {
        return self.subflow(to: LoginFlowController(), context: context)
                   .map { .end(()) }
                   .back { .prompt(()) }
                   .cancel { .prompt(()) }
    }

    func onSignUp(state: OnboardState, context: Void) -> Promise<OnboardState.SignUp> {
        return self.subflow(to: SignUpFlowController(), context: context)
                   .map { .end(()) }
                   .back { .prompt(()) }
                   .cancel { .prompt(()) }
    }

    func onSkip(state: OnboardState, context: Void) -> Promise<OnboardState.Skip> {
        return Promise.value(.end(()))
    }

}
