package dev.beehive.remotebees.flow

import com.inmotionsoftware.flowkit.android.StateMachineActivity
import com.inmotionsoftware.promisekt.Promise
import com.inmotionsoftware.promisekt.map
import dev.beehive.remotebees.fragment.SignUpFragment

class SignUpFlowController : StateMachineActivity<SignUpState, Unit, Unit>(), SignUpStateMachine {

    override fun onBegin(state: SignUpState, context: Unit): Promise<SignUpState.FromBegin> {
        return Promise.value(SignUpState.FromBegin.Prompt(context))
    }

    override fun onPrompt(state: SignUpState, context: Unit): Promise<SignUpState.FromPrompt> {
        return this.subflow2(fragment = SignUpFragment::class.java, context = Unit)
                    .map {
                        when (it) {
                            is SignUpFragment.Response.SignUp -> {
                                Promise.value(SignUpState.FromPrompt.SubmitSignUp(Unit)) as SignUpState.FromPrompt
                            }
                        }
                    }
    }

    override fun onSubmitSignUp(
        state: SignUpState,
        context: Unit
    ): Promise<SignUpState.FromSubmitSignUp> {
        return Promise.value(SignUpState.FromSubmitSignUp.End(Unit))
    }

}
