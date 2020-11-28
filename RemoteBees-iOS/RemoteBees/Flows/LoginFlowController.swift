//
//  LoginFlowController.swift
//  RemoteBees
//

import UIKit
import PromiseKit
import FlowKit
import RemoteBeesFlow

class LoginFlowController: ViewCache, NavStateMachine, LoginStateMachine {
    var nav: UINavigationController!

    func onBegin(state: LoginState, context: Void) -> Promise<LoginState.Begin> {
        Promise.value(.prompt(context))
    }

    func onPrompt(state: LoginState, context: Void) -> Promise<LoginState.Prompt> {
        return self.subflow(to: LoginView.self, context: nil)
                    .map {
                        switch $0 {
                            case .login(let email, let password):
                                return .submitLogin(())
                            case .forgotPassword:
                                return .forgotPassword(())
                        }
                    }
    }

    func onForgotPassword(state: LoginState, context: Void) -> Promise<LoginState.ForgotPassword> {
        return self.subflow(to: ForgotPasswordView.self, context: context)
                   .map {
                        switch $0 {
                            case .sendResetPassword(let email):
                                return .submitForgotPassword(())
                        }
                   }
                  .back { .prompt(()) }
                  .cancel { .prompt(()) }
    }
    
    func onSubmitLogin(state: LoginState, context: Void) -> Promise<LoginState.SubmitLogin> {
        return Promise.value(.end(()))
    }
    
    func onSubmitForgotPassword(state: LoginState, context: Void) -> Promise<LoginState.SubmitForgotPassword> {
        return Promise.value(.prompt(()))
    }

}
