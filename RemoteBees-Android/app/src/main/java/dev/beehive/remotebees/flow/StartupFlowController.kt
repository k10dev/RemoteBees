/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.flow

import com.inmotionsoftware.flowkit.android.StateMachineActivity
import com.inmotionsoftware.promisekt.Promise
import com.inmotionsoftware.promisekt.map
import dev.beehive.remotebees.app.AppProxy

class StartupFlowController : StateMachineActivity<StartupState, Unit, Int>(), StartupStateMachine {

    override fun onBegin(state: StartupState, context: Unit): Promise<StartupState.FromBegin> {
        return Promise.value(StartupState.FromBegin.Entry(context))
    }

    override fun onEntry(state: StartupState, context: Unit): Promise<StartupState.FromEntry> {
        val preferences = AppProxy.proxy.preferences
        return if (preferences.firstTimeUsed) {
            preferences.firstTimeUsed = false
            Promise.value(StartupState.FromEntry.Onboard(context))
        } else {
            Promise.value(StartupState.FromEntry.JobBoard(context))
        }
    }

    override fun onOnboard(state: StartupState, context: Unit): Promise<StartupState.FromOnboard> {
        return this.subflow(stateMachine= OnboardFlowController::class.java, state=OnboardState.Begin(context))
                    .map {
                        StartupState.FromOnboard.JobBoard(Unit)
                    }
    }

    override fun onJobBoard(
        state: StartupState,
        context: Unit
    ): Promise<StartupState.FromJobBoard> {
        return this.subflow(stateMachine = JobBoardFlowController::class.java, state=JobBoardState.Begin(context))
                    .map {
                        StartupState.FromJobBoard.End(1)
                    }
    }

}
