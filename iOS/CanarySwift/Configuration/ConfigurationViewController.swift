//
//  ConfigurationViewController.swift
//  Canary
//
//  Created by Rake Yang on 2020/2/22.
//  Copyright © 2020 BinaryParadise. All rights reserved.
//

import Foundation
import SwifterSwift
import SwiftyJSON

class ConfigurationViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)
    var remoteConfig: [ConfigGroup] {
        return ConfigProvider.shared.remoteConfig
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "远程配置"
        view.backgroundColor = UIColor(hex: 0xF4F5F6)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = view.backgroundColor
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(cellWithClass: ConfigurationItemViewCell.self)
                
        ConfigProvider.shared.fetchRemoteConfig { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}
    
extension ConfigurationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return remoteConfig.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remoteConfig[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return remoteConfig[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ConfigurationItemViewCell.self)
        let item = remoteConfig[indexPath.section].items[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.comment
        cell.selectedBtn.isSelected = item.name == ConfigProvider.shared.currentName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let config = remoteConfig[indexPath.section]
        let item = config.items[indexPath.row]
        let vc = ConfigurationItemViewController(configItem: item)
        vc.title = item.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
