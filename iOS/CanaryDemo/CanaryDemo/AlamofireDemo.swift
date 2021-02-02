//
//  AlamofireDemo.swift
//  CanaryDemo
//
//  Created by Rake Yang on 2020/12/13.
//

import Foundation
import Alamofire

@objc class AlamofireDemo: NSObject {
    @objc func test() -> Void {
        Alamofire.request("https://quan.suning.com/getSysTime.do").response { response in
            DDLogDebug("\(String(data: response.data ?? Data(), encoding: .utf8) ?? "")")
        }        
    }
}
