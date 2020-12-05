//
//  OnboardView.swift
//  RemoteBees
//

import SwiftUI
import FlowKit
import PromiseKit

enum OnboardResponse {
    case login
    case signup
    case skip
}

struct OnboardView: FlowableView {
    typealias Input = Void
    typealias Output = OnboardResponse

    public let resolver: Resolver<Output>

    init(context: Void, resolver: Resolver<Output>) {
        self.resolver = resolver
    }

    var body: some View {
        VStack(alignment: .center) {
            Spacer()

            Button(L10n.Action.login, action: self.onLogIn)
                .font(.system(size: 20))
                .foregroundColor(Color.white)
                .frame(width: 250, height: 50, alignment: .center)
                .background(RoundedCorners(color: Color.beehiveBrand, tl: 10, tr: 10, bl: 10, br: 10))
                .padding(.bottom, 20)
            
            Button(L10n.Action.signUp, action: self.onSignUp)
                .font(.system(size: 20))
                .foregroundColor(Color.white)
                .frame(width: 250, height: 50, alignment: .center)
                .background(RoundedCorners(color: Color.beehiveBrand, tl: 10, tr: 10, bl: 10, br: 10))
                .padding(.bottom, 20)

            Button(L10n.Action.skip, action: self.onSkip)
                .font(.system(size: 20))
                .foregroundColor(Color.beehiveBrand)

            Spacer()
        }
        .navigationBarHidden(true)
    }
    
    private func onLogIn() {
        self.resolve(.login)
    }
    
    private func onSignUp() {
        self.resolve(.signup)
    }

    private func onSkip() {
        self.resolve(.skip)
    }

}
