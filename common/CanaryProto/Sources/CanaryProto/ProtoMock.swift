//
//  ProtoMock.swift
//  
//
//  Created by Rake Yang on 2021/6/23.
//

import Foundation

public struct ProtoMock: Codable {
    @Default.Zero
    public var id: Int
    public var name: String
    public var method: String
    public var path: String
    public var updatetime: Int64?
    @Default.Zero
    public var groupid: Int
    public var groupname: String?
    public var uid: Int?
    @Default.Zero
    public var sceneid: Int
    @Default.False
    public var enabled: Bool
    public var scenes: [ProtoMockScene]?    
}

public struct ProtoMockGroup: Codable {
    @Default.Zero
    public var id: Int
    public var name: String
    public var appid: Int
    public var uid: Int
    public var mocks: [ProtoMock]?
}
