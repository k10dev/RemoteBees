/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    @State var name: String
    var loopMode: LottieLoopMode = .loop
    var animationView = AnimationView()

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()

        animationView.animation = Animation.named(name)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = self.loopMode

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        animationView.play()
    }
}

#if DEBUG
struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        let view = LottieView(name: "bee-flying")
        view.animationView.play()
        return view
    }
}
#endif
