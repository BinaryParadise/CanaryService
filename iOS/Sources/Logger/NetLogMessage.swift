//
//  NetLogMessage.swift
//  Canary
//
//  Created by Rake Yang on 2020/3/21.
//  Copyright © 2020年 BinaryParadise inc. All rights reserved.
//

import Foundation

class NetLogMessage {
    var method: String?
    var requestURL: URL?
    var requestHeaderFields: [AnyHashable: Any]?
    var responseHeaderFields: [AnyHashable: Any]?
    var requestBody: Data?
    var responseBody: Data?
    var statusCode: Int?
    
    init(request: NSURLRequest, response: HTTPURLResponse, data: Data?) {
        method = request.httpMethod;
        requestURL = request.url;
        requestHeaderFields = request.allHTTPHeaderFields;
        requestBody = (request as URLRequest).httpBodyData;
        responseHeaderFields = response.allHeaderFields
        responseBody = data
        statusCode = response.statusCode
    }
}

extension URLRequest {
    var httpBodyData: Data? {
        if let stream = httpBodyStream {
            var data = Data()
            stream.open()
            
            let bufferSize = 1024
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            defer {
                buffer.deallocate()
            }
            while stream.hasBytesAvailable {
                let len = stream.read(buffer, maxLength: bufferSize)
                if len > 0 && stream.streamError == nil {
                    data.append(buffer, count: len)
                }
            }
            stream.close()
            return data.count > 0 ? data:nil
        }
        return httpBody
    }
}
