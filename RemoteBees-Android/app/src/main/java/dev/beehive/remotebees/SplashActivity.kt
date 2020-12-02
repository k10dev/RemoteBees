package dev.beehive.remotebees

import android.os.Bundle
import com.inmotionsoftware.flowkit.android.BootstrapActivity
import com.inmotionsoftware.flowkit.back
import com.inmotionsoftware.flowkit.cancel
import com.inmotionsoftware.promisekt.Promise
import com.inmotionsoftware.promisekt.thenMap
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
            .thenMap {
                // this.subflow(stateMachine = StartupFlowController::class.java, state = StartupState.Begin(Unit))

                val preferences = AppProxy.proxy.preferences
                if (preferences.firstTimeUsed) {
                    preferences.firstTimeUsed = false
                    this.subflow(stateMachine= OnboardFlowController::class.java, state=OnboardState.Begin(context))
                } else {
                    this.subflow(stateMachine = JobBoardFlowController::class.java, state= JobBoardState.Begin(context))
                }
            }
            .back {
                exitProcess(0)
            }
            .cancel {
                exitProcess(0)
            }
    }

}
