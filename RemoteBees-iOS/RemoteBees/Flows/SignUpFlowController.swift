//
//  SignUpFlowController.swift
//  RemoteBees
//

import UIKit
import PromiseKit
import FlowKit
import RemoteBeesFlow

class SignUpFlowController: ViewCache, NavStateMachine, SignUpStateMachine {
    var nav: UINavigationController!

    func onBegin(state: SignUpState, context: Void) -> Promise<SignUpState.Begin> {
        return Promise.value(.prompt(context))
    }
    
    func onPrompt(state: SignUpState, context: Void) -> Promise<SignUpState.Prompt> {
        return self.subflow(to: SignUpView.self, context: nil)
                    .map {
                        switch $0 {
                            case let .signUp(firstName, lastName, email, password):
                                let context = SignUpContext(
                                                firstName: firstName,
                                                lastName: lastName,
                                                email: email,
                                                password: password
                                            )
                                return .submitSignUp(context)
                        }
                    }
    }
    
    func onSubmitSignUp(state: SignUpState, context: SignUpContext) -> Promise<SignUpState.SubmitSignUp> {
        return Promise.value(.end(()))
    }

}
