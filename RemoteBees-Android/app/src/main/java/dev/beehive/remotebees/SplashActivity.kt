package dev.beehive.remotebees

import android.os.Bundle
import com.inmotionsoftware.flowkit.android.BootstrapActivity
import com.inmotionsoftware.flowkit.back
import com.inmotionsoftware.flowkit.cancel
import com.inmotionsoftware.promisekt.Promise
import com.inmotionsoftware.promisekt.thenMap
import dev.beehive.remotebees.app.AppProxy
import dev.beehive.remotebees.flow.StartupFlowController
import dev.beehive.remotebees.flow.StartupState
import kotlin.system.exitProcess

class SplashActivity : BootstrapActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)
    }

    override fun onBegin(state: State, context: Unit): Promise<Unit> {
        return AppProxy.proxy.initialize()
            .thenMap {
                this.subflow(stateMachine = StartupFlowController::class.java, state = StartupState.Begin(Unit))
            }
            .back {
                exitProcess(0)
            }
            .cancel {
                exitProcess(0)
            }
    }

}
