//
//  MajorViewController.swift
//  Canary
//
//  Created by Rake Yang on 2020/12/10.
//

import Foundation
import SnapKit

func safeBottom() -> CGFloat {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    } else {
        return 0
    }
}

private enum PluginType: Int {
    case env
    case mock
    case webview
}

class MajorViewController: UIViewController {
    var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    private var datas: [[String: PluginType]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "金丝雀"
        view.backgroundColor = UIColor(hex: 0xF4F5F6)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .done, target: self, action: #selector(onBackButton))
        
        tableView.backgroundColor = view.backgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(cellWithClass: UITableViewCell.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadData()
    }
    
    func reloadData() -> Void {
        datas.removeAll()
        datas.append(["环境配置": .env])
        if CanaryMockURLProtocol.isEnabled {
            datas.append(["Mock数据": .mock])
            
            MockManager.shared.fetchGroups {
                
            }
        }
        
        #if DEBUG
        datas.append(["WKWebView": .webview])
        #endif
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: .done, target: self, action: #selector(onProfileButton))
        tableView.reloadData()
    }
    
    @objc func onBackButton() {
        dismiss(animated: true) {
            CanarySwift.shared.lock.unlock()
        }
    }
    
    @objc func onProfileButton() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    deinit {
        CanarySwift.shared.lock.unlock()
    }
}

extension MajorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self)
        cell.textLabel?.text = datas[indexPath.row].keys.first ?? ""
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.accessoryType = .disclosureIndicator
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let type = datas[safe: indexPath.row]?.values.first else { return }
        if type == .env {
            navigationController?.pushViewController(ConfigurationViewController(), animated: true)
        } else if type == .mock {
            navigationController?.pushViewController(MockDataViewController(), animated: true)
        } else if type == .webview {
            navigationController?.pushViewController(CanaryWebViewController(), animated: true)
        }
    }
}
