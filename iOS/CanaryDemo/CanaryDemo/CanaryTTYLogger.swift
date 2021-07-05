//
//  CanaryTTYLogger.swift
//  CanaryDemo
//
//  Created by Rake Yang on 2020/12/25.
//

import Foundation
import Canary

public class CanaryTTYLogger: DDAbstractLogger {
    @objc static let shared = CanaryTTYLogger()
    public override func log(message logMessage: DDLogMessage) {
        CanaryManager.shared.storeLogMessage(dict: logMessage.dictionaryWithValues(forKeys: CanaryManager.StoreLogKeys), timestamp: logMessage.timestamp.timeIntervalSince1970)
    }
}
