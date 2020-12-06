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

class SignUpFragment: FlowFragment<Unit, SignUpFragment.Response>() {

    sealed class Response {
        data class SignUp(val firstname: String, val lastName: String, val email: String, val password: String): Response()
    }

    override fun onInputAttached(input: Unit) {

    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_sign_up, container, false)
        view.findViewById<Button>(R.id.submitBtn)
            .setOnClickListener { this.onSubmit() }
        return view
    }

    private fun onSubmit() {
        this.resolve(Response.SignUp(firstname = "", lastName = "", email = "", password = ""))
    }

}
