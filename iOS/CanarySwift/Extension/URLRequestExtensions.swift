//
//  URLRequestExtensions.swift
//  Canary
//
//  Created by Rake Yang on 2021/1/5.
//

import Foundation
import WebKit

#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
import MobileCoreServices
#else
import CoreServices
#endif

extension URLRequest {
    static func get(with path: String, completion: ((Result, Error?) -> Void)?) -> Void {
        let r = NSMutableURLRequest(url: URL(string: "\(CanarySwift.shared.baseURL ?? "")\(path)")!)
        r.httpMethod = "GET"
        if let user = CanarySwift.shared.user() {
            r.setValue(user.token, forHTTPHeaderField: "Canary-Access-Token")
        }
        r.setValue(userAgent(), forHTTPHeaderField: "User-Agent")
        print("GET \(r.url?.absoluteString ?? "")")
        URLSession.shared.dataTask(with: r as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                do {
                    let result = try JSONDecoder().decode(Result.self, from: data ?? Data())
                    if result.code == 401 {
                        CanarySwift.shared.logout()
                        CanarySwift.shared.show()
                        return
                    }
                    completion?(result, error)
                } catch {
                    completion?(Result(code: 1, error: error.localizedDescription, data: nil, timestamp: Date().timeIntervalSince1970), error)
                }
            }
        }.resume()
    }
    
    static func post(with path: String, params: [String : AnyHashable]?, completion: ((Result, Error?) -> Void)?) -> Void {
        let r = NSMutableURLRequest(url: URL(string: "\(CanarySwift.shared.baseURL ?? "")\(path)")!)
        r.httpMethod = "POST"
        r.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let user = CanarySwift.shared.user() {
            r.setValue(user.token, forHTTPHeaderField: "Canary-Access-Token")
        }
        r.setValue(userAgent(), forHTTPHeaderField: "User-Agent")
        r.httpBody = params?.jsonData()
        print("POST \(r.url?.absoluteString ?? "")")
        URLSession.shared.dataTask(with: r as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                do {
                    let result = try JSONDecoder().decode(Result.self, from: data ?? Data())
                    completion?(result, error)
                } catch {
                    completion?(Result(code: 1, error: data?.string(encoding: .utf8), data: nil, timestamp: Date().timeIntervalSince1970), error)
                }
            }
        }.resume()
    }
    
    private static func userAgent() -> String {
        var userAgent = ""
        let info = Bundle.main.infoDictionary!
        userAgent = "\(info[kCFBundleExecutableKey as String] ?? "")/\(info["CFBundleShortVersionString"]!) (\(UIDevice.current.model); iOS \(UIDevice.current.systemVersion); Scale/\(UIScreen.main.scale))"
        return userAgent
    }
}
