//
//  CanaryProto.swift
//
//
//  Created by Rake Yang on 2021/6/11.
//

import Foundation

/// 金丝雀公共支持库
public class CanaryProto {
    public class func generateIdentify() -> String {
        return UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
    }
}
