//
//  URLRequestExtensions.swift
//  Canary
//
//  Created by Rake Yang on 2021/1/5.
//

import Foundation

extension URLRequest {
    static func get(with path: String, completion: ((Result, Error?) -> Void)?) -> Void {
        let r = NSMutableURLRequest(url: URL(string: "\(CanarySwift.shared.baseURL ?? "")\(path)")!)
        r.httpMethod = "GET"
        if let user = CanarySwift.shared.user() {
            r.setValue(user.token, forHTTPHeaderField: "Canary-Access-Token")
        }
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
    
    static func post(with path: String, params: [String : String]?, completion: ((Result, Error?) -> Void)?) -> Void {
        let r = NSMutableURLRequest(url: URL(string: "\(CanarySwift.shared.baseURL ?? "")\(path)")!)
        r.httpMethod = "POST"
        r.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let user = CanarySwift.shared.user() {
            r.setValue(user.token, forHTTPHeaderField: "Canary-Access-Token")
        }
        r.httpBody = params?.jsonData()
        print("POST \(r.url?.absoluteString ?? "")")
        URLSession.shared.dataTask(with: r as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                do {
                    let result = try JSONDecoder().decode(Result.self, from: data ?? Data())
                    completion?(result, error)
                } catch {
                    completion?(Result(code: 1, error: error.localizedDescription, data: nil, timestamp: Date().timeIntervalSince1970), error)
                }
            }
        }.resume()
    }
}
