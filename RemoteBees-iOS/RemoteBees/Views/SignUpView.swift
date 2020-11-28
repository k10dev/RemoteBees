//
//  SignUpView.swift
//  RemoteBees
//

import SwiftUI
import FlowKit
import PromiseKit

enum SignUpViewResponse {
    case signUp(firstName: String, lastName: String, email: String, password: String)
}

struct SignUpView: FlowableView {
    
    typealias Input = Error?
    typealias Output = SignUpViewResponse

    public let resolver: Resolver<Output>

    @State var error: Error?
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    init(context: Error?, resolver: Resolver<Output>) {
        self.resolver = resolver
        self.error = context
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 50)

            TextField("First Name", text: $firstName)
                .padding()
                .background(Color.lightGrey)
                .cornerRadius(5.0)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 5)
            TextField("Last Name", text: $lastName)
                .padding()
                .background(Color.lightGrey)
                .cornerRadius(5.0)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 5)
            TextField("Email", text: $email)
                .padding()
                .background(Color.lightGrey)
                .cornerRadius(5.0)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 5)
            SecureField("Password", text: $password)
                .padding()
                .background(Color.lightGrey)
                .cornerRadius(5.0)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 20)

            Button("SIGN UP", action: self.onSignUp)
                .font(.system(size: 20))
                .foregroundColor(Color.white)
                .frame(width: 250, height: 50, alignment: .center)
                .background(RoundedCorners(color: Color.beehiveBrand, tl: 10, tr: 10, bl: 10, br: 10))
                .padding(.bottom, 20)

            Spacer()
        }
    }

    private func onSignUp() {
        self.resolve(.signUp(firstName: self.firstName, lastName: self.lastName, email: self.email, password: self.password))
    }

}
