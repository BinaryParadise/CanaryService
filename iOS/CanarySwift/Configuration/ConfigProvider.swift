//
//  ConfigProvider.swift
//  Canary
//
//  Created by Rake Yang on 2020/12/11.
//

import Foundation
import SwiftyJSON

let kMCRemoteConfig = "remoteConfig"
let kMCCurrentName  = "currenName"

public class ConfigProvider {
    private var userDefaults = UserDefaults(suiteName: suiteName)!
    var remoteConfig: [ConfigGroup] = []
    var selectedConfig: ConfigItem?
    var currentName: String? {
        didSet {
            userDefaults.set(object: currentName, forKey: kMCCurrentName)
            userDefaults.synchronize()
        }
    }
    
    public static let shared = ConfigProvider()
        
    init() {
        let jsonData = userDefaults.object(forKey: kMCRemoteConfig)
        if let jsonData = jsonData as? Data {
            do {
                remoteConfig = try JSONDecoder().decode([ConfigGroup].self, from: jsonData)
            } catch {
                print("\(#file).\(#function)+\(#line)\(error)")
            }
        }
        if remoteConfig.count == 0 {
            if let configPath = Bundle.main.path(forResource: "Peregrine.bundle/RemoteConfig.json", ofType: nil) {
                do {
                    remoteConfig = try JSONDecoder().decode([ConfigGroup].self, from: Data(contentsOf: URL(fileURLWithPath: configPath)))
                } catch {
                    print("\(#file).\(#function)+\(#line) \n\(error)")
                }
            }
        }
        currentName = userDefaults.object(forKey: kMCCurrentName) as? String
        switchToCurrentConfig()
    }

    func fetchRemoteConfig(completion: @escaping (() -> Void)) {
        var confURL = "/api/conf/full?appkey=\(CanarySwift.shared.appSecret)"
        URLRequest.get(with: confURL) { [weak self] (result, error) in
            if result.code == 0 {
                self?.processRemoteConfig(data: result.data)
            }
            completion()
        }
    }

    func processRemoteConfig(data: JSON?) {
        guard let data = data else { return }
        do {
            remoteConfig = try JSONDecoder().decode([ConfigGroup].self, from: data.rawData())
            try userDefaults.set(object: data.rawData(), forKey: kMCRemoteConfig)
            switchToCurrentConfig()
        } catch {
            print("\(#file).\(#function)+\(#line) \(error)")
        }
    }

    func switchToCurrentConfig() {
        var selectedItem: ConfigItem?
        var defaultItem: ConfigItem?
        remoteConfig.forEach { (group) in
            group.items.forEach { (item) in
                if item.defaultTag ?? false {
                    defaultItem = item
                }
                if item.name == currentName {
                    selectedItem = item
                }
            }
        }
        
        if selectedItem == nil {
            selectedItem = defaultItem
        }
        
        if let selectedItem = selectedItem {
            currentName = selectedItem.name
        }
        selectedConfig = selectedItem
    }
    
    func stringValue(for key: String, def: String?) -> String? {
        let item = selectedConfig?.subItems?.first(where: { (subItem) -> Bool in
            return subItem.name == key
        })
        return item?.value ?? def
    }
}
