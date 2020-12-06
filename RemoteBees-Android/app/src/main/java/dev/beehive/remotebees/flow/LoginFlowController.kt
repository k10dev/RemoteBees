/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.flow

import com.inmotionsoftware.flowkit.android.StateMachineActivity
import com.inmotionsoftware.flowkit.back
import com.inmotionsoftware.flowkit.cancel
import com.inmotionsoftware.promisekt.Promise
import com.inmotionsoftware.promisekt.map
import dev.beehive.remotebees.fragment.ForgotPasswordFragment
import dev.beehive.remotebees.fragment.LoginFragment

class LoginFlowController : StateMachineActivity<LoginState, Unit, Int>(), LoginStateMachine {

    override fun onBegin(state: LoginState, context: Unit): Promise<LoginState.FromBegin> {
        return Promise.value(LoginState.FromBegin.Prompt(Unit))
    }

    override fun onPrompt(state: LoginState, context: Unit): Promise<LoginState.FromPrompt> {
        return this.subflow2(fragment = LoginFragment::class.java, context = context)
                    .map {
                        when (it) {
                            is LoginFragment.Response.ForgotPassword -> {
                                LoginState.FromPrompt.ForgotPassword(Unit)
                            }
                            is LoginFragment.Response.Login -> {
                                LoginState.FromPrompt.SubmitLogin(LoginContext(email = it.email, password = it.password))
                            }
                        }
                    }
    }

    override fun onForgotPassword(
        state: LoginState,
        context: Unit
    ): Promise<LoginState.FromForgotPassword> {
        return this.subflow2(fragment = ForgotPasswordFragment::class.java, context = context)
                    .map {
                        when (it) {
                            is ForgotPasswordFragment.Response.SendResetPassword -> {
                                LoginState.FromForgotPassword.SubmitForgotPassword(it.email)
                                        as LoginState.FromForgotPassword
                            }
                        }
                    }
                    .back { LoginState.FromForgotPassword.Prompt(Unit) }
                    .cancel { LoginState.FromForgotPassword.Prompt(Unit) }
    }

    override fun onSubmitLogin(
        state: LoginState,
        context: LoginContext
    ): Promise<LoginState.FromSubmitLogin> {
        return Promise.value(LoginState.FromSubmitLogin.End(0))
    }

    override fun onSubmitForgotPassword(
        state: LoginState,
        context: String
    ): Promise<LoginState.FromSubmitForgotPassword> {
        return Promise.value(LoginState.FromSubmitForgotPassword.Prompt(Unit))
    }

}
