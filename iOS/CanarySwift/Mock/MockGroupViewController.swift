//
//  MockGroupViewController.swift
//  Pods
//
//  Created by Rake Yang on 2020/12/10.
//

import Foundation
import SwifterSwift
import SnapKit
import SwiftyJSON

class MockGroupViewController: UIViewController {
    var tableView = UITableView(frame: .zero, style: .grouped)
    var groups: [MockGroup] {
        return MockManager.shared.groups
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mock数据"
        view.backgroundColor = UIColor(hex: 0xF4F5F6)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .done, target: self, action: #selector(onBackButton))
        tableView.backgroundColor = view.backgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(cellWithClass: MockDataGroupViewCell.self)
        
        MockManager.shared.fetchGroups { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func onBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension MockGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MockDataGroupViewCell.self)
        cell.config(with: groups[safe: indexPath.row])
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MockDataViewController()
        vc.group = groups[safe: indexPath.row]
        navigationController?.pushViewController(vc)
    }
}

class MockDataGroupViewCell: UITableViewCell {
    let switchBtn = UISwitch()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config(with group: MockGroup?) {
        guard let group = group else { return }
        textLabel?.text = group.name
    }
}
