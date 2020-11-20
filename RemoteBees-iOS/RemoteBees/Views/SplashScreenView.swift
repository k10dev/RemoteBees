//
//  SplashScreenView.swift
//  RemoteBees
//

import SwiftUI

struct SplashScreenView: View {
    var preferredStatusBarStyle: UIStatusBarStyle = .lightContent
    var prefersStatusBarHidden: Bool = false

     var body: some View {
         ZStack {
//             SkipcartBrandView()
//             LoadingView()
//                 .frame(width: 120.0, height: 120.0, alignment: .center)
//                 .offset(x: 100.0, y: 0.0)
            
//            Color.orange.edgesIgnoringSafeArea(.all)
//            Text("Remote Bees 2")
         }
        .navigationBarHidden(true)
     }
 }

#if DEBUG
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
#endif
