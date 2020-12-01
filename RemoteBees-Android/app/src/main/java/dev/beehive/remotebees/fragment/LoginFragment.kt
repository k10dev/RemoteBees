package dev.beehive.remotebees.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import com.inmotionsoftware.flowkit.android.FlowFragment
import dev.beehive.remotebees.R

class LoginFragment: FlowFragment<Unit, LoginFragment.Response>() {

    sealed class Response {
        object ForgotPassword: Response()
        data class Login(val email: String, val password: String): Response()
    }

    override fun onInputAttached(input: Unit) {
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_login, container, false)
        view.findViewById<Button>(R.id.submitBtn)
            .setOnClickListener { this.onSubmit() }
        view.findViewById<TextView>(R.id.forgotPasswordText)
            .setOnClickListener { this.onForgotPassword() }
        return view
    }

    private fun onSubmit() {
        this.resolve(Response.Login(
            email = "", password = ""
        ))
    }

    private fun onForgotPassword() {
        this.resolve(Response.ForgotPassword)
    }

}
