//
//  MockDefines.swift
//  Pods
//
//  Created by Rake Yang on 2020/12/11.
//

import Foundation

let AutomaticMode = 0

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
    
    /// 激活状态
    var enabled: Bool
    var sceneid: Int?
    var scenes: [MockScene]?
    
    /// 匹配场景，未指定时，默认第一个场景生效
    func matchScene(sceneid: Int?, request: URLRequest) -> Int? {
        if sceneid ?? 0 == AutomaticMode {
            var queryParameters: [String : String]?
            if request.httpMethod == "GET" {
                queryParameters = request.url?.queryParameters
            } else if request.httpMethod == "POST" {
                let dict = (try? request.httpBodyData?.jsonObject()) as? [String : Any]
                queryParameters = dict?.mapValues({ value -> String in
                    if let v = value as? String {
                        return v
                    } else if let v = value as? Int {
                        return v.string
                    } else if let v = value as? Float {
                        return v.string
                    }
                    return String(describing: value)
                })
            }
            
            //匹配参数
            if let queryParameters = queryParameters {
                var lowerQuery: [String : String] = [:]
                queryParameters.forEach { (key, value) in
                    lowerQuery[key.lowercased()] = value
                }
                for scene in scenes ?? [] {
                    if scene.params?.count == 0 || scene.id == 0 {
                        continue
                    }
                    if scene.params?.all(matching: { (param) -> Bool in
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
