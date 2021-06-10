//
//  ProjectController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import Networking
import PerfectHTTP

/// 应用管理
class ProjectController {
    @Mapping(path: "/project/list")
    var projectList: RequestHandler = { (request, response) in
        
    }
}
