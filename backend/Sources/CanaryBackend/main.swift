//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectSession

LogDebug("\(CommandLine.arguments)")
ServerArgument.main()

let _ = ConfController()
let _ = HomeController()
let _ = WebSocketController()
let _ = ProjectController()
let _ = UserController()
let _ = MockController()

let driver = SessionMemoryDriver()

try? HTTPServer.launch(name: conf.name,
                       port: conf.port,
                      routes: routes,
                      requestFilters: [
                        driver.requestFilter,
                        (ContentFilter(), .high)
                      ],
                      responseFilters: [
                        driver.responseFilter,
                        (PerfectHTTPServer.HTTPFilter.contentCompression(data: [:]), HTTPFilterPriority.high)
                      ]).wait()
