//
//  MockDefines.swift
//  Pods
//
//  Created by Rake Yang on 2020/12/11.
//

import Foundation

let AutomaticMode = -1

class MockParam: Codable {
    var name: String
    var value: String
    var comment: String?
}

struct MockScene: Codable {
    var id: Int
    var name: String
    var params: [MockParam]?
}

class MockData: Codable {
    var id: Int
    var name: String
    var path: String
    var scenes: [MockScene]?
    
    /// 匹配场景，未指定时，默认第一个场景生效
    func matchScene(sceneid: Int?, request: URLRequest) -> Int? {
        if sceneid == AutomaticMode {
            //匹配参数
            if let queryParameters = request.url?.queryParameters {
                var lowerQuery: [String : String] = [:]
                queryParameters.forEach { (key, value) in
                    lowerQuery[key.lowercased()] = value
                }
                for scene in scenes ?? [] {
                    if scene.params?.count == 0 || scene.id == -1 {
                        continue
                    }
                    if scene.params?.all(matching: { (param) -> Bool in
                        print("\(param.name.lowercased())=\(lowerQuery[param.name.lowercased()]) \(param.name.lowercased())=\(param.value)")
                        return lowerQuery[param.name.lowercased()] == param.value
                    }) == true {
                        return scene.id
                    }
                }
            }
        }
        guard let match = scenes?.first(where: { (scene) -> Bool in
            scene.id == sceneid && sceneid != AutomaticMode
        }) else { return scenes?.first(where: { (ms) -> Bool in
            ms.id > 0
        })?.id }
        return match.id
    }
}

struct MockGroup: Codable {
    var id: Int
    var name: String
    var mocks: [MockData]?
}
