/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

package dev.beehive.remotebees.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import com.inmotionsoftware.flowkit.android.FlowFragment
import dev.beehive.remotebees.R

class OnboardFragment: FlowFragment<Unit, OnboardFragment.Response>() {

    enum class Response {
        Login,
        SignUp,
        Skip
    }

    override fun onInputAttached(input: Unit) {
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_onboard, container, false)
        view.findViewById<Button>(R.id.loginBtn)
            .setOnClickListener { this.onLogin() }
        view.findViewById<Button>(R.id.signUpBtn)
            .setOnClickListener { this.onSignUp() }
        view.findViewById<Button>(R.id.skipBtn)
            .setOnClickListener { this.onSkip() }
        return view
    }

    private fun onLogin() {
        this.resolve(Response.Login)
    }

    private fun onSignUp() {
        this.resolve(Response.SignUp)
    }

    private fun onSkip() {
        this.resolve(Response.Skip)
    }

}
