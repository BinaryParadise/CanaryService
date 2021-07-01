//
//  ConfController.swift
//  
//
//  Created by Rake Yang on 2021/6/18.
//

import Foundation
import CanaryProto

class ConfController {
    @Mapping(path: "/conf/list")
    var list: ResultHandler = { request, response in
        let rs = try ConfMapper.shared.findAll(pid: request.pid, type: request.intParamValue("type"))
        return ProtoResult(entry: rs ?? [])
    }
    
    @Mapping(path: "/conf/full")
    var full: ResultHandler = { request, response in
        let app = try ProjectMapper.shared.findBy(appKey: request.stringParamValue("appkey"))
        let rs = try ConfMapper.shared.findFull(pid: app?.id ?? 0)
        return ProtoResult(entry: try JSONEncoder().encode(rs))
    }
}
