/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees

import android.os.Bundle
import com.inmotionsoftware.flowkit.android.BootstrapActivity
import com.inmotionsoftware.flowkit.back
import com.inmotionsoftware.flowkit.cancel
import com.inmotionsoftware.promisekt.Promise
import com.inmotionsoftware.promisekt.asVoid
import com.inmotionsoftware.promisekt.then
import dev.beehive.remotebees.app.AppProxy
import dev.beehive.remotebees.flow.*
import kotlin.system.exitProcess

class SplashActivity : BootstrapActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)
    }

    override fun onBegin(state: State, context: Unit): Promise<Unit> {
        return AppProxy.proxy.initialize()
            .then {
                 this.subflow(stateMachine = StartupFlowController::class.java, state = StartupState.Begin(Unit)).asVoid()
            }
            .back {
                exitProcess(0)
            }
            .cancel {
                exitProcess(0)
            }
    }

}
