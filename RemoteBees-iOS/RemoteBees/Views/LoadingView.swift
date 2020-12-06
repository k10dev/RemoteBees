/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

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
