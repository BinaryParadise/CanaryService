//
//  MockGroupViewController.swift
//  Pods
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

class CanaryViewController: UIViewController {
    var tableView: UITableView = {
        if #available(iOS 13.0, *) {
            return UITableView(frame: .zero, style: .insetGrouped)
        } else {
            return UITableView(frame: .zero, style: .grouped)
        }
    }()
    var datas: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "金丝雀"
        view.backgroundColor = UIColor(hex: 0xF4F5F6)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .done, target: self, action: #selector(onBackButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: .done, target: self, action: #selector(onProfileButton))
        
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
        datas =  ["环境配置", "Mock数据", "WKWebView"]
        tableView.reloadData()
    }
    
    @objc func onBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onProfileButton() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    deinit {
        CanarySwift.shared.lock.unlock()
    }
}

extension CanaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self)
        cell.textLabel?.text = datas[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.accessoryType = .disclosureIndicator
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            navigationController?.pushViewController(ConfigurationViewController(), animated: true)
        } else if indexPath.row == 1 {
            navigationController?.pushViewController(MockGroupViewController(), animated: true)
        } else if indexPath.row == 2 {
            navigationController?.pushViewController(CanaryWebViewController(), animated: true)
        }
    }
}
