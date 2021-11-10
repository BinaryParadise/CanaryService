//
//  ProjectController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import PerfectHTTP
import Proto
import SwiftyJSON

/// 应用管理
class ProjectController {
    @Mapping(path: "/project/list")
    var projectList: ResultHandler = { (request, response) in
        let rs = ProjectMapper.shared.findAll(uid: Int(request.session?.userid ?? "0") ?? 0)
        return ProtoResult(entry: JSON(rs))
    }
    
    @Mapping(path: "/project/update", method: [.post])
    var update: ResultHandler = { (request, response) in
        var app = try JSONDecoder().decode(ProtoProject.self, from: JSON(request.postDictionary).rawData())
        if app.id > 0 {
            let old = try ProjectMapper.shared.findBy(appId: app.id)
            app.identify = old?.identify
            try ProjectMapper.shared.update(app)
        } else {
            app.identify = CanaryProto.generateIdentify()
            try ProjectMapper.shared.insertNew(app)
        }
        return ProtoResult(.none)
    }
    
    @Mapping(path: "/project/delete/{id}", method: [.post])
    var delete: ResultHandler = { (request, response) in
        try ProjectMapper.shared.delete(appid: request.urlVariables.intValue("id"))
        return ProtoResult(.none)
    }
    
    @Mapping(path: "/project/appsecret/reset", method: [.post])
    var resetAppKey: ResultHandler = { request, response throws in
        if var app = try ProjectMapper.shared.findBy(appId: request.intParamValue("id")) {
            app.identify = CanaryProto.generateIdentify()
            try ProjectMapper.shared.update(app)
            return ProtoResult(.none)
        } else {
            return ProtoResult(.nodata)
        }
    }
}
