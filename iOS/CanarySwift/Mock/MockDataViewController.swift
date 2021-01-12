//
//  MockDataViewController.swift
//  Pods
//
//  Created by Rake Yang on 2020/12/10.
//

import Foundation

class MockDataViewController: UIViewController {
    var group: MockGroup?
    var tableView = UITableView(frame: .zero, style: .grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = group?.name
        view.backgroundColor = UIColor(hex: 0xF4F5F6)
        
        tableView.backgroundColor = view.backgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(tableView)
        tableView.register(cellWithClass: MockDataViewCell.self)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
}

extension MockDataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return group?.mocks?.count ?? 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MockDataViewCell.self)
        cell.onSwitch = { [weak self] (mock, isOn) in
            URLRequest.post(with: "/api/mock/active", params: ["sceneid": mock.sceneid, "enabled": isOn, "id": mock.id]) { [weak self] (result, error) in
                if result.code == 0 {
                    mock.enabled = isOn
                    self?.tableView.reloadData()
                } else {
                    self?.show(faield: result.error)
                }
            }
        }
        cell.config(mock:group?.mocks?[safe: indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58+50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

class MockDataViewCell: UITableViewCell {
    var mock: MockData?
    let nameLabel = UILabel()
    let pathLabel = UILabel()
    let switchBtn = UISwitch()
    let collectView = UICollectionView(frame: .zero, collectionViewLayout: {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 6
        flowLayout.estimatedItemSize = CGSize(width: 100, height: 30)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 4, right: 16)
        return flowLayout;
    }())
    var onSwitch:((MockData, Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //名称
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.setContentCompressionResistancePriority(.defaultLow+1, for: .horizontal)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10)
        }
        
        //路径
        pathLabel.numberOfLines = 2
        pathLabel.textColor = UIColor(hex: 0x666666)
        pathLabel.font = UIFont.systemFont(ofSize: 13)
        pathLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentView.addSubview(pathLabel)
        pathLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp_bottom).offset(6)
        }
        
        //开关
        contentView.addSubview(switchBtn)
        switchBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(nameLabel)
            make.left.greaterThanOrEqualTo(nameLabel.snp_right).offset(20)
            make.left.greaterThanOrEqualTo(pathLabel.snp_right).offset(10)
        }
        switchBtn.addTarget(self, action: #selector(onSwitchChanged(_:)), for: .valueChanged)
        
        //场景（左右滑动)
        collectView.backgroundColor = backgroundColor
        collectView.dataSource = self
        collectView.delegate = self
        contentView.addSubview(collectView)
        collectView.register(cellWithClass: ItemCell.self)
        collectView.snp.makeConstraints { (make) in
            make.top.equalTo(pathLabel.snp_bottom).offset(8)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    @objc func onSwitchChanged(_ sender: UISwitch) -> Void {
        guard let mock = mock else { return }
        onSwitch?(mock, sender.isOn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(mock: MockData?) {
        guard let mock = mock else { return }
        self.mock = mock
        switchBtn.isOn = mock.enabled
        nameLabel.text = mock.name
        pathLabel.text = "路径：\(mock.path)"
        collectView.reloadData()
    }
    
    class ItemCell: UICollectionViewCell {
        let selectedBtn = UIButton(type: .custom)

        override init(frame: CGRect) {
            super.init(frame: frame)
            //选中状态
            selectedBtn.isUserInteractionEnabled = false
            selectedBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            selectedBtn.setTitleColor(UIColor(hex: 0x666666), for: .normal)
            selectedBtn.setTitleColor(UIColor(hex: 0x4587E6), for: .selected)
            contentView.addSubview(selectedBtn)
            selectedBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(4)
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview().offset(-4)
            }
            
        }
        
        func config(scene:MockScene?) {
            guard let scene = scene else { return }
            selectedBtn.setTitle("◉\(scene.name)", for: .normal)
            selectedBtn.setTitle("◉\(scene.name)", for: .selected)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
}

extension MockDataViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mock?.scenes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ItemCell.self, for: indexPath)
        if let mock = mock {
            if let scene = mock.scenes?[safe: indexPath.row] {
                cell.config(scene: scene)
                if mock.sceneid ?? 0 == AutomaticMode {
                    cell.selectedBtn.isSelected = indexPath.row == 0
                } else {
                    cell.selectedBtn.isSelected = mock.sceneid == scene.id
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mock = mock else { return }
        if let scene = mock.scenes?[safe: indexPath.row] {
            URLRequest.post(with: "/api/mock/active", params: ["sceneid": scene.id == 0 ? nil : scene.id, "enabled": mock.enabled, "id": mock.id]) { [weak self] (result, error) in
                if result.code == 0 {
                    mock.sceneid = scene.id == 0 ? nil : scene.id
                    self?.collectView.reloadData()
                }
            }
        }
    }
}
