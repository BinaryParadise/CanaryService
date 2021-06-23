//
//  ProtoMockParam.swift
//  
//
//  Created by Rake Yang on 2021/6/23.
//

import Foundation

public struct ProtoMockParam: Codable {
    @Default.Zero
    public var id: Int
    public var name: String
    public var value: String
    public var comment: String?
    public var sceneid: Int
    public var updatetime: Int64?
}
