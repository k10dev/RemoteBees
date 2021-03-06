/***************************************************************************
 * This source file is part of the RemoteBees open source project.         *
 *                                                                         *
 * Licensed under the MIT License. See LICENSE for license information     *
 ***************************************************************************/

import UIKit
import PromiseKit

public enum JobSearchType {
    case category(String)
    case companyName(String)
    case listing(String)
}

public protocol BeehiveService {
    
    func getAllJobs() -> Promise<[Job]>

    func getJob(_ id: Int) -> Promise<Job?>

    func searchJobs(by type: JobSearchType) -> Promise<[Job]>

    func getCompanyLogo(_ id: Int) -> Promise<UIImage?>

}
