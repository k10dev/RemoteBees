//
//  ForgotPasswordView.swift
//  RemoteBees
//

import SwiftUI
import FlowKit
import PromiseKit

enum ForgotPasswordViewResponse {
    case sendResetPassword(email: String)
}

struct ForgotPasswordView: FlowableView {
    
    typealias Input = Void
    typealias Output = ForgotPasswordViewResponse

    public let resolver: Resolver<Output>

    @State private var email: String = ""
    
    init(context: Void, resolver: Resolver<Output>) {
        self.resolver = resolver
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 30)

            TextField("Email", text: $email)
                .padding(10)
                .background(Color.lightGrey)
                .cornerRadius(5.0)
                .padding(.horizontal, 10)
                .padding(.bottom, 20)

            Button("Submit", action: self.onSubmit)
                .font(.system(size: 20))
                .foregroundColor(Color.white)
                .frame(width: 250, height: 50, alignment: .center)
                .background(RoundedCorners(color: Color.beehiveBrand, tl: 10, tr: 10, bl: 10, br: 10))

            Spacer()
        }
        .navigationBarTitle("Password Reset")
    }

    private func onSubmit() {
        self.resolve(.sendResetPassword(email: self.email))
    }

}