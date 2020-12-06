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
import dev.beehive.remotebees.fragment.SignUpFragment

class SignUpFlowController : StateMachineActivity<SignUpState, Unit, Int>(), SignUpStateMachine {

    override fun onBegin(state: SignUpState, context: Unit): Promise<SignUpState.FromBegin> {
        return Promise.value(SignUpState.FromBegin.Prompt(context))
    }

    override fun onPrompt(state: SignUpState, context: Unit): Promise<SignUpState.FromPrompt> {
        return this.subflow2(fragment = SignUpFragment::class.java, context = Unit)
                    .map {
                        when (it) {
                            is SignUpFragment.Response.SignUp -> {
                                SignUpState.FromPrompt.SubmitSignUp(
                                    SignUpContext(
                                        firstName = it.firstname,
                                        lastName = it.lastName,
                                        email = it.email,
                                        password = it.password
                                    )
                                ) as SignUpState.FromPrompt
                            }
                        }
                    }
    }

    override fun onSubmitSignUp(
        state: SignUpState,
        context: SignUpContext
    ): Promise<SignUpState.FromSubmitSignUp> {
        return Promise.value(SignUpState.FromSubmitSignUp.End(1))

        // Subflow reusability example
        /*
        return this.subflow(stateMachine = LoginFlowController::class.java, state = LoginState.Begin(context))
                .map {
                    SignUpState.FromSubmitSignUp.End(1) as SignUpState.FromSubmitSignUp
                }
                .back {
                    SignUpState.FromSubmitSignUp.Prompt(Unit)
                }
                .cancel {
                    SignUpState.FromSubmitSignUp.Prompt(Unit)
                }
        */
    }

}
