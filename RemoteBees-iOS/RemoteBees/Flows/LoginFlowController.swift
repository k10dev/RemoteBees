/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

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
                            case let .login(email, password):
                                return .submitLogin(LoginContext(email: email, password: password))
                            case .forgotPassword:
                                return .forgotPassword(())
                        }
                    }
    }

    func onForgotPassword(state: LoginState, context: Void) -> Promise<LoginState.ForgotPassword> {
        return self.subflow(to: ForgotPasswordView.self, context: context)
                   .map {
                        switch $0 {
                            case let .sendResetPassword(email):
                                return .submitForgotPassword(email)
                        }
                   }
                  .back { .prompt(()) }
                  .cancel { .prompt(()) }
    }
    
    func onSubmitLogin(state: LoginState, context: LoginContext) -> Promise<LoginState.SubmitLogin> {
        return Promise.value(.end(()))
    }
    
    func onSubmitForgotPassword(state: LoginState, context: String) -> Promise<LoginState.SubmitForgotPassword> {
        return Promise.value(.prompt(()))
    }

}
