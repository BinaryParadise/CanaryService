//
//  UserAuth.swift
//  Canary
//
//  Created by Rake Yang on 2021/1/5.
//

import Foundation

let ServerHostKey = "center.canary.com"
let UserAuthKey = "User.AuthKey"

class CanaryApp: Codable {
    var name: String
}

class UserAuth: Codable {
    var name: String
    var token: String
    var rolename: String
    var app: CanaryApp?
}
