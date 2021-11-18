//
//  File.swift
//  
//
//  Created by Rake Yang on 2021/11/18.
//

import Foundation
import Vapor
import Proto
import SwiftyJSON

extension Response {    
    class func success(_ data: Data? = nil) -> Response {
        do {
            let r: Data = try JSONEncoder().encode(ProtoResult(entry: data as Any))
            return .init(status: .ok, version: .http1_1, headers: [:], body: .init(data: r))
        } catch {
            LogError("\(error.localizedDescription)")
            return failed(.system)
        }
    }
    
    class func failed(_ error: ProtoError) -> Response {
        let r: [String : AnyHashable] = ["code": error.rawValue, "msg": error.description]
        return .init(status: .ok, version: .http1_1, headers: [:], body: .init(data: r.data ?? Data()))
    }
}
