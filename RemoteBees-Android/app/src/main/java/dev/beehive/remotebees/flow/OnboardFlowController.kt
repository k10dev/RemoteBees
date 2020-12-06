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
import dev.beehive.remotebees.fragment.OnboardFragment

class OnboardFlowController : StateMachineActivity<OnboardState, Unit, Int>(), OnboardStateMachine {

    override fun onBegin(state: OnboardState, context: Unit): Promise<OnboardState.FromBegin> {
        return Promise.value(OnboardState.FromBegin.Prompt(context))
    }

    override fun onPrompt(state: OnboardState, context: Unit): Promise<OnboardState.FromPrompt> {
        return this.subflow2(fragment = OnboardFragment::class.java, context = Unit)
                    .map {
                        when (it) {
                            OnboardFragment.Response.Login -> {
                                OnboardState.FromPrompt.Login(Unit)
                            }
                            OnboardFragment.Response.SignUp -> {
                                OnboardState.FromPrompt.SignUp(Unit)
                            }
                            OnboardFragment.Response.Skip -> {
                                OnboardState.FromPrompt.Skip(Unit)
                            }
                        }
                    }
    }

    override fun onLogin(state: OnboardState, context: Unit): Promise<OnboardState.FromLogin> {
        return this.subflow(stateMachine = LoginFlowController::class.java, state = LoginState.Begin(context))
                    .map { OnboardState.FromLogin.End(1) as OnboardState.FromLogin }
                    .back { OnboardState.FromLogin.Prompt(Unit) }
                    .cancel { OnboardState.FromLogin.Prompt(Unit) }
    }

    override fun onSignUp(state: OnboardState, context: Unit): Promise<OnboardState.FromSignUp> {
        return this.subflow(stateMachine = SignUpFlowController::class.java, state = SignUpState.Begin(context))
                    .map { OnboardState.FromSignUp.End(1) as OnboardState.FromSignUp }
                    .back { OnboardState.FromSignUp.Prompt(Unit) }
                    .cancel { OnboardState.FromSignUp.Prompt(Unit) }
    }

    override fun onSkip(state: OnboardState, context: Unit): Promise<OnboardState.FromSkip> {
        return Promise.value(OnboardState.FromSkip.End(1))
    }

}
