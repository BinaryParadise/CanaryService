//
//  MCRemoveConfigItemViewController.m
//  MCFrontendKit
//
//  Created by Rake Yang on 2020/2/23.
//

import Foundation
import SwiftyJSON

class ConfigurationItemViewController: UIViewController {
    var item: ProtoConf
    let tableView = UITableView(frame: .zero, style: .grouped)
    let tipLabel = UILabel()
    @objc let applyButton = UIButton(type: .custom)
    
    init(configItem: ProtoConf) {
        item = configItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0xF4F5F6)

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = view.backgroundColor;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        view.addSubview(tableView)
        
        tableView.register(cellWithClass: ConfigurationItemViewCell.self)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-57 - safeBottom())
        }
        
        self.applyButton.layer.cornerRadius = 8;
        self.applyButton.layer.masksToBounds = true;
        self.applyButton.backgroundColor = .cyan;
        applyButton.setTitleColor(.purple, for: .normal)
        applyButton.setTitle("应用", for: .normal)
        view.addSubview(applyButton)
        applyButton.addTarget(self, action: #selector(applyConfig), for: .touchUpInside)
        applyButton.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp_bottom).offset(6)
            make.size.equalTo(CGSize(width: 180, height: 40))
            make.centerX.equalToSuperview()
        }
        
        self.tipLabel.text = "应用后建议重启App"
        self.tipLabel.textColor = .gray
        self.tipLabel.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(applyButton)
            make.top.equalTo(applyButton.snp_bottom).offset(6)
        }
    }
    
    @objc func applyConfig() {
        ConfigProvider.shared.currentName = item.name
        dismiss(animated: true, completion: nil)
    }
}

extension ConfigurationItemViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.subItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ConfigurationItemViewCell.self)
        let subItem = item.subItems![indexPath.row]
        cell.titleLabel.text = subItem.name
        cell.valueLabel.text = subItem.value
        cell.extraLabel.text = subItem.comment
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subItem = item.subItems![indexPath.row]
        return ConfigurationItemViewCell.heightForObject(obj: subItem.comment)
    }
}
