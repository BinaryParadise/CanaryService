//
//  File.swift
//  
//
//  Created by Rake Yang on 2021/6/16.
//

import Foundation
import SwiftyJSON

public struct ProtoDevice: Codable {
    public var ipAddrs: [String : [String : String]]?
    public var simulator: Bool
    public var appVersion: String
    public var osName: String
    public var osVersion: String
    public var modelName: String
    public var name: String
    public var profile: [String : JSON]?
    public var deviceId: String    
}
