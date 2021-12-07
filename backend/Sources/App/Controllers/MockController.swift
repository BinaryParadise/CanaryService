//
//  MockController.swift
//  
//
//  Created by Rake Yang on 2021/6/23.
//

import Foundation
import Proto
import SwiftyJSON
import Vapor

class MockController: RouteCollection {
    var token: String?
    
    func boot(routes: RoutesBuilder) throws {
        routes.group("mock") { mock in
            mock.get("app", "whole", use: appWhole)
            mock.get("app", "scene", ":id", use: appScene)
            mock.get("list", use: list)
            mock.post("update", use: update)
            mock.post("active", use: active)
            mock.post("delete", ":id", use: delete)
            
            mock.group("group") { group in
                group.get("list", use: groupList)
                group.post("update", use: groupUpdate)
                group.post("delete", ":id", use: groupDelete)
            }
            
            mock.group("scene") { scene in
                scene.get("list", ":mockid", use: sceneList)
                scene.post("update", use: updateScene)
                scene.post("delete", ":id", use: deleteScene)
                scene.post("active", use: activeScene)
            }
            
            mock.group("param") { param in
                
                param.post("update") { request -> Response in
                    try MockMapper.updateParam(param: request.content.decode(ProtoMockParam.self))
                    return .success()
                }
                
                param.post("delete", ":id") { request -> Response in
                    try MockMapper.deleteParam(paramid: request.parameters.intValue("id"))
                    return .success()
                }
            }
        }
    }

    func appWhole(request: Request) throws -> Response {
        if var groups = try MockMapper.findAllGroup(pid: request.pid, uid: request.uid)?.decode([ProtoMockGroup].self) {
            for (index, item) in groups.enumerated() {
                if var mocks = try MockMapper.findAllMock(pid: request.pid, uid: request.uid, paging: Paging(["pageSize": "1000", "pageNum": "1"]), groupId: item.id)?.decode([ProtoMock].self) {
                    for (i, mock) in mocks.enumerated() {
                        mocks[i].scenes = try MockMapper.findAllScene(mockid: mock.id)?.decode([ProtoMockScene].self)
                        for (y, scene) in (mocks[i].scenes ?? []).enumerated() {
                            mocks[i].scenes?[y].params = try MockMapper.findAllParam(sceneid: scene.id)?.decode([ProtoMockParam].self)
                        }
                        mocks[i].scenes?.insert(ProtoMockScene(mockid: mock.id, name: "自动"), at: 0)
                    }
                    groups[index].mocks = mocks
                }
            }
            return .success(try JSONEncoder().encode(groups))
        }
        return .success()
    }
    
    func list(request: Request) throws -> Response {
        let paging = try request.query.decode(Paging.self)
        let r = try MockMapper.findAllMock(pid: request.pid, uid: request.uid, paging: paging, groupId: request.query.intValue("groupid"))
        return .success(try JSON(r as Any).rawData())
    }
    
    func update(request: Request) throws -> Response {
        let mock = try request.content.decode(ProtoMock.self)
        try MockMapper.update(mock: mock)
        return .success()
    }
    
    func active(request: Request) throws -> Response {
        try MockMapper.activeMock(mockid: request.content.intValue("mockid"), enabled: false)
        return .success()
    }
    
    func delete(request: Request) throws -> Response {
        try MockMapper.deleteMock(mockid: request.parameters.intValue("id"))
        return .success()
    }
    
    func groupList(request: Request) throws -> Response {
        let r = try MockMapper.findAllGroup(pid: request.pid, uid: request.uid)
        return .success(try JSON(r as Any).rawData())
    }
    
    func groupUpdate(request: Request) throws -> Response {
        try MockMapper.updateGroup(request.content.decode(ProtoMockGroup.self))
        return .success()
    }
    
    func groupDelete(request: Request) throws -> Response {
        try MockMapper.deleteGroup(request.parameters.intValue("id"))
        return .success()
    }
    
    func sceneList(request: Request) throws -> Response {
        var scenes = try MockMapper.findAllScene(mockid: request.parameters.intValue("mockid"))?.decode([ProtoMockScene].self)
        for (index, item) in (scenes ?? []).enumerated() {
            scenes?[index].params = try MockMapper.findAllParam(sceneid: item.id)?.decode([ProtoMockParam].self)
        }
        return .success(try JSONEncoder().encode(scenes))
    }
    
    func appScene(request: Request) throws -> Response {
        let scene = try MockMapper.findScene(sceneId: request.parameters.intValue("id"))?.decode(ProtoMockScene.self)
        if let scene = scene {
            let response: Response = .init(status: .ok, version: .http1_1, headers: [:], body: .init(string: scene.response))
            response.headers.replaceOrAdd(name: .contentType, value: "application/json; charset=utf8")
            response.headers.replaceOrAdd(name: "Scene-Id", value: String(scene.id))
            response.headers.replaceOrAdd(name: "Scene-Name", value: scene.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            return response
        }
        return .failed(.nodata)
    }
    
    func updateScene(request: Request) throws -> Response {
        try MockMapper.updateScene(scene: request.content.decode(ProtoMockScene.self))
        return .success()
    }
    
    func deleteScene(request: Request) throws -> Response {
        try MockMapper.deleteScene(sceneid: request.parameters.intValue("id"))
        return .success()
    }
    
    func activeScene(request: Request) throws -> Response {
        let dict = try request.body.dictionary()
        try MockMapper.activeScene(dict.intValue("sceneid"), enabled: dict.boolValue("enabled"), mockid: dict.intValue("mockid"))
        return .success()
    }
}
