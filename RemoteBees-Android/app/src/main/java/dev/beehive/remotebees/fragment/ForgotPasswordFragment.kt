package dev.beehive.remotebees.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import com.inmotionsoftware.flowkit.android.FlowFragment
import dev.beehive.remotebees.R

class ForgotPasswordFragment: FlowFragment<Unit, ForgotPasswordFragment.Response>() {

    sealed class Response {
        data class SendResetPassword(val email: String): Response()
    }

    override fun onInputAttached(input: Unit) {

    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_forgot_password, container, false)
        view.findViewById<Button>(R.id.submitBtn)
            .setOnClickListener { this.onSubmit() }
        return view
    }

    private fun onSubmit() {
        this.resolve(Response.SendResetPassword(email = ""))
    }

}
