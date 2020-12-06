/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import Foundation

public struct LoginContext: Hashable, Codable {
    let email: String
    let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
