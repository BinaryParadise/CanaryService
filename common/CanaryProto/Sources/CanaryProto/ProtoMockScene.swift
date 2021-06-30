//
//  File.swift
//  
//
//  Created by Rake Yang on 2021/6/23.
//

import Foundation

public struct ProtoMockScene: Codable {
    @Default.Zero
    public var id: Int
    public var name: String
    @Default.Empty
    public var response: String
    public var updatetime: Int64?
    public var mockid: Int
    public var activeid: Int?
    public var params: [ProtoMockParam]?
        
    public init(mockid: Int, name: String) {
        self.id = 0
        self.mockid = mockid
        self.name = name
        self.response = ""
    }
}
