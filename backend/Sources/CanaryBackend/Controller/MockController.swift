//
//  MockController.swift
//  
//
//  Created by Rake Yang on 2021/6/23.
//

import Foundation
import CanaryProto
import SwiftyJSON

class MockController {
    @Mapping(path: "/mock/app/whole")
    var appWhole: ResultHandler = { req, res in
        if var groups = try MockMapper.findAllGroup(pid: req.pid, uid: req.uid)?.decode([ProtoMockGroup].self) {
            for (index, item) in groups.enumerated() {
                if var mocks = try MockMapper.findAllMock(pid: req.pid, uid: req.uid, paging: Paging(["pageSize": "1000", "pageNum": "1"]), groupId: item.id)?.decode([ProtoMock].self) {
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
            return .entry(try JSONEncoder().encode(groups))
        }
        return .done
    }
    
    @Mapping(path: "/mock/list")
    var mockList: ResultHandler = { request, response in
        let paging = Paging(request.getDictionary)
        return .entry(try MockMapper.findAllMock(pid: request.pid, uid: request.uid, paging: paging, groupId: request.getDictionary.intValue("groupid")))
    }
    
    @Mapping(path: "/mock/update", method: [.post])
    var updateMock: ResultHandler = { request, response in
        let mock = try request.postDictionary.decode(ProtoMock.self)
        try MockMapper.update(mock: mock)
        return .done
    }
    
    @Mapping(path: "/mock/active", method: [.post])
    var activeMock: ResultHandler = { req, res in
        try MockMapper.activeMock(mockid: req.postDictionary.intValue("mockid"), enabled: req.postDictionary.boolValue("enabled"))
        return .done
    }
    
    @Mapping(path: "/mock/delete/{id}", method: [.post])
    var deleteMock: ResultHandler = {  request, response in
        try MockMapper.deleteMock(mockid: request.urlVariables.intValue("id"))
        return .done
    }
    
    @Mapping(path: "/mock/group/list")
    var groupList: ResultHandler = { request, response in
        return .entry(try MockMapper.findAllGroup(pid: request.pid, uid: request.uid))
    }
    
    @Mapping(path: "/mock/group/update", method: [.post])
    var groupUpdate: ResultHandler = { request, response in
        try MockMapper.updateGroup(request.postDictionary.decode(ProtoMockGroup.self))
        return .done
    }
    
    @Mapping(path: "/mock/group/delete/{id}", method: [.post])
    var groupDelete: ResultHandler = { request, resposne in
        try MockMapper.deleteGroup(request.urlVariables.intValue("id"))
        return .done
    }
    
    @Mapping(path: "/mock/scene/list/{mockid}")
    var sceneList: ResultHandler = { request, response in
        var scenes = try MockMapper.findAllScene(mockid: request.urlVariables.intValue("mockid"))?.decode([ProtoMockScene].self)
        for (index, item) in (scenes ?? []).enumerated() {
            scenes?[index].params = try MockMapper.findAllParam(sceneid: item.id)?.decode([ProtoMockParam].self)
        }
        return .entry(try JSONEncoder().encode(scenes))
    }
    
    @Mapping(path: "/mock/app/scene/{id}", method: [.get, .post])
    var sceneDetail: ResultHandler = { request, response in
        let scene = try MockMapper.findScene(sceneId: request.urlVariables.intValue("id"))?.decode(ProtoMockScene.self)
        if let scene = scene {
            response.setHeader(.contentType, value: "application/json; charset=utf-8")
            response.setHeader(.custom(name: "Scene-Id"), value: String(scene.id))
            response.setHeader(.custom(name: "Scene-Name"), value: scene.name.stringByEncodingURL)
            try response.setBody(json: scene.response.jsonDecode())
            response.completed(status: .ok)
        } else {
            response.completed(status: .notFound)
        }
        return nil
    }
    
    @Mapping(path: "/mock/scene/update", method: [.post])
    var updateScene: ResultHandler = { request, response in
        try MockMapper.updateScene(scene: request.postDictionary.decode(ProtoMockScene.self))
        return .done
    }
    
    @Mapping(path: "/mock/param/update", method: [.post])
    var updateParam: ResultHandler = { request, response in
        try MockMapper.updateParam(param: request.postDictionary.decode(ProtoMockParam.self))
        return .done
    }
    
    @Mapping(path: "/mock/param/delete/{id}", method: [.post])
    var deleteParam: ResultHandler = { request, response in
        try MockMapper.deleteParam(paramid: request.urlVariables.intValue("id"))
        return .done
    }
    
    @Mapping(path: "/mock/scene/delete/{id}", method: [.post])
    var deleteScene: ResultHandler = {  request, response in
        try MockMapper.deleteScene(sceneid: request.urlVariables.intValue("id"))
        return .done
    }
    
    @Mapping(path: "/mock/scene/active", method: [.post])
    var activeScene: ResultHandler = { request, response in
        try MockMapper.activeScene(request.postDictionary.intValue("sceneid"), enabled: request.postDictionary.boolValue("enabled"), mockid: request.postDictionary.intValue("mockid"))
        return .done
    }
}
