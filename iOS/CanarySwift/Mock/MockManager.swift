//
//  MockManager.swift
//  Pods
//
//  Created by Rake Yang on 2020/12/10.
//

import Foundation
import SwiftyJSON

let suiteName       = "com.binaryparadise.canary"
let MockGroupURL    = "/api/mock/app/whole"

/// 接口状态
struct MockSwitch: Codable {
    var isEnabled: Bool
    var sceneId: Int?
    var automatic: Bool?
}

@objc public class MockManager: NSObject {
    private var userDefaults = UserDefaults(suiteName: suiteName)!
    
    /// 接口开关
    private var mockSwitchs: [String : MockSwitch] = [:]
    private var mockMap: [String : MockData] = [:]
    var groups: [MockGroup] = [] {
        didSet {
            groups.forEach { (group) in
                group.mocks?.forEach({ (mock) in
                    mockMap[mock.path] = mock
                })
            }
        }
    }
    @objc public static let shared = MockManager()
    override init() {
        super.init()
        if let data = userDefaults.object(forKey: "switchs") as? Data {
            do {
                mockSwitchs = try JSONDecoder().decode([String: MockSwitch].self, from: data)
            } catch {
                
            }
        }
        fetchGroups {
            
        }
    }
    
    /// 接口开关状态
    func switchFor(mockid: Int) -> MockSwitch {
        guard let mockS = mockSwitchs[mockid.string] else { return MockSwitch(isEnabled: false, sceneId: nil, automatic: false) }
        return mockS
    }
    
    /// 设置接口状态
    func setSwitch(for mockid:Int, isOn: Bool) {
        var mockS = switchFor(mockid: mockid)
        mockS.isEnabled = isOn
        self.mockSwitchs[mockid.string] = mockS
        userDefaults.set(object: mockSwitchs, forKey: "switchs")
        userDefaults.synchronize()
    }
    
    /// 指定场景
    func setScene(for mockid:Int, sceneid: Int?) {
        var mockS = switchFor(mockid: mockid)
        mockS.sceneId = sceneid
        self.mockSwitchs[mockid.string] = mockS
        userDefaults.set(object: mockSwitchs, forKey: "switchs")
        userDefaults.synchronize()
    }
    
    func shouldIntercept(for request: URLRequest) -> (should:Bool, url: URL?) {
        //完全匹配
        let path = request.url?.path ?? ""
        if path == MockGroupURL {
            return (false, nil)
        }
        var matchMock = mockMap[path]
        if matchMock == nil  {
            //正则匹配
            matchMock = mockMap.values.first(where: { (item) -> Bool in
                do {
                    let regexStr = matchParameter(path: item.path)
                    let regex = try NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
                    let count = regex.matches(in: path, options: .reportProgress, range: NSRange(location: 0, length: path.count)).count
                    if count > 0 {
                        return true
                    }
                } catch {
                    print("正则匹配：\(error)")
                }
                return false
            })
        }
        guard let mock = matchMock else { return (false, nil) }
        let match = switchFor(mockid: mock.id)
        var intercept = false
        var url: URL?
        if match.isEnabled {
            if let scendid = mock.matchScene(sceneid: match.sceneId, request: request) {
                intercept = true
                var queryStr = ""
                if let q = request.url?.query {
                    queryStr.append("?\(q)")
                }
                url = URL(string: "\(CanarySwift.shared.baseURL ?? "")/api/mock/app/scene/\(scendid)\(queryStr)")
            }

        }
        return (intercept, url)
    }
    
    // 替换参数占位正则表达式
    func matchParameter(path: String) -> String {
        do {
            let mstr = NSString(string: path).mutableCopy() as! NSMutableString
            let regex = try NSRegularExpression(pattern: "\\{param[0-9]+\\}", options: .caseInsensitive)
            let count = regex.replaceMatches(in: mstr, options: .reportProgress, range: NSRange(location: 0, length: path.count), withTemplate: "([0-9./-A-Za-z]+)")
            return mstr as String
        } catch {
            print("\(error)")
        }
        return path
    }
    
    func fetchGroups(completion: @escaping (() -> Void)) -> Void {
        URLSession.shared.dataTask(with: CanarySwift.shared.requestURL(with: MockGroupURL)) { [weak self] (data, response, error) in
            do {
                let data = JSON(data)["data"]
                self?.groups = try JSONDecoder().decode([MockGroup].self, from: data.rawData())
            } catch {
                print("\(#file).\(#function)+\(#line) \(error)")
            }
            completion()
        }.resume()
    }
}
