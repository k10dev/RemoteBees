//
//  LoginView.swift
//  RemoteBees
//

import SwiftUI
import FlowKit
import PromiseKit

enum LoginViewResponse {
    case login(email: String, password: String)
    case forgotPassword
}

struct LoginView: FlowableView {
    
    typealias Input = Error?
    typealias Output = LoginViewResponse

    public let resolver: Resolver<Output>

    @State var error: Error?
    @State var email: String = ""
    @State var password: String = ""
    
    init(context: Error?, resolver: Resolver<Output>) {
        self.resolver = resolver
        self.error = context
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 50)

            TextField("Email", text: $email)
                .padding()
                .background(Color.lightGrey)
                .cornerRadius(5.0)
                .padding(10)
            SecureField("Password", text: $password)
                .padding()
                .background(Color.lightGrey)
                .cornerRadius(5.0)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 20)

            Button("LOG IN", action: self.onLogIn)
                .font(.system(size: 20))
                .foregroundColor(Color.white)
                .frame(width: 250, height: 50, alignment: .center)
                .background(RoundedCorners(color: Color.beehiveBrand, tl: 10, tr: 10, bl: 10, br: 10))
                .padding(.bottom, 20)

            Button("Forgot Password", action: self.onForgotPassword)
                .font(.system(size: 15))
                .foregroundColor(Color.beehiveBrand)

            Spacer()
        }
    }

    private func onLogIn() {
        self.resolve(.login(email: self.email, password: self.password))
    }

    private func onForgotPassword() {
        self.resolve(.forgotPassword)
    }

}
