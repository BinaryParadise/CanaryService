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
                    print("\(#file).\(#function)+\(#line)\(error)")
                }
            }
        }
        currentName = userDefaults.object(forKey: kMCCurrentName) as? String
        switchToCurrentConfig()
    }

    func fetchRemoteConfig(completion: @escaping (() -> Void)) {
        var confURL = "\(CanarySwift.shared.baseURL!)/api/conf/full?appkey=\(CanarySwift.shared.appSecret)"
        URLSession.shared.dataTask(with: URL(string: confURL)!) { [weak self] (data, response, error) in
            if error == nil {
                do {
                    try self?.processRemoteConfig(dict: JSON(data))
                } catch {
                    print("\(#file).\(#function)+\(#line)\(error)")
                }
            }
            completion()
        }.resume()
    }

    func processRemoteConfig(dict: JSON?) {
        guard let dict = dict else { return }
        if dict["code"].int ?? 0 == 0 {
            do {
                var data = dict["data"]
                remoteConfig = try JSONDecoder().decode([ConfigGroup].self, from: data.rawData())
                try userDefaults.set(object: data.rawData(), forKey: kMCRemoteConfig)
                switchToCurrentConfig()
            } catch {
                print("\(#file).\(#function)+\(#line)\(error)")
            }
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
