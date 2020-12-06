/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import SwiftUI
import RemoteBeesFlow

struct JobRow: View {
    var job: JobItem
    @State private var image: Image? = nil

    var body: some View {
        HStack {
            if self.image != nil {
                self.image!
                    .resizable()
                    .frame(width: 60, height: 60)
                    .scaledToFill()
            } else {
                Image(uiImage: Asset.Assets.logoPlaceholder.image)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .scaledToFit()
            }

            Spacer().frame(width: 10)
            VStack(alignment: .leading) {
                Text(self.job.title)
                    .font(.headline)
                Text(self.job.companyName)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                Text(self.job.category)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                Text(self.job.salary)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
        }
        .onAppear {
            AppProxy.proxy.serviceManager.beehiveService.getCompanyLogo(self.job.id)
                    .done {
                        guard let image = $0 else { return }
                        self.image = Image(uiImage: image)
                    }
                    .cauterize()
        }
    }
}
