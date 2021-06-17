//
//  ProjectController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import Networking
import PerfectHTTP
import CanaryProto
import SwiftyJSON

/// 应用管理
class ProjectController {
    @Mapping(path: "/project/list")
    var projectList: ResultHandler = { (request, response) in
        do {
            return ProtoResult(data: JSON(ProjectMapper.shared.findAll(uid: Int(request.session?.userid ?? "0")!)))
        } catch {
            print("\(error)")
        }
        return ProtoResult(.system)
    }
}
