//
//  LoadingView.swift
//  RemoteBees
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        LottieView(name: "bee-flying")
    }
}

#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
#endif
