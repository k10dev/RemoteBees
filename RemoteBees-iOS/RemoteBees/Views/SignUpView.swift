/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

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

    @State private var error: Error?
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    init(context: Error?, resolver: Resolver<Output>) {
        self.resolver = resolver
        self.error = context
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 30)

            TextField(L10n.Placeholder.firstName, text: $firstName)
                .padding(10)
                .background(Color.lightGrey)
                .cornerRadius(5.0)
                .padding(.horizontal, 10.0)
                .padding(.bottom, 5.0)
            TextField(L10n.Placeholder.lastName, text: $lastName)
                .padding(10)
                .background(Color.lightGrey)
                .cornerRadius(5.0)
                .padding(.horizontal, 10.0)
                .padding(.bottom, 5.0)
            TextField(L10n.Placeholder.email, text: $email)
                .padding(10)
                .background(Color.lightGrey)
                .cornerRadius(5.0)
                .padding(.horizontal, 10.0)
                .padding(.bottom, 5.0)
            SecureField(L10n.Placeholder.password, text: $password)
                .padding(10)
                .background(Color.lightGrey)
                .cornerRadius(5.0)
                .padding(.horizontal, 10.0)
                .padding(.bottom, 20.0)

            Button(L10n.Action.submit, action: self.onSignUp)
                .font(.system(size: 20))
                .foregroundColor(Color.white)
                .frame(width: 250, height: 50, alignment: .center)
                .background(RoundedCorners(color: Color.beehiveBrand, tl: 10, tr: 10, bl: 10, br: 10))
                .padding(.bottom, 20)

            Spacer()
        }
        .navigationBarTitle(L10n.Title.signUp)
    }

    private func onSignUp() {
        self.resolve(.signUp(firstName: self.firstName, lastName: self.lastName, email: self.email, password: self.password))
    }

}
