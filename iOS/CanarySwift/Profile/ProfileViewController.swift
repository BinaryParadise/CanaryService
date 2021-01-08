//
//  ProfileViewController.swift
//  Canary
//
//  Created by Rake Yang on 2021/1/4.
//

import Foundation
import SnapKit

/// 个人资料
class ProfileViewController: UIViewController {

    var loginView: LoginView?
    var infoView: InfoView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "登录"
        view.backgroundColor = UIColor.white
        
        configView()
    }
    
    func configView() -> Void {
        
        infoView?.removeFromSuperview()
        infoView = nil
        loginView?.removeFromSuperview()
        loginView = nil
        if let user = CanarySwift.shared.user() {
            infoView = InfoView(frame: .zero)
            view.addSubview(infoView!)
            infoView?.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.top.equalTo(view.readableContentGuide).offset(30)
            })
            infoView?.logouButton.addTarget(self, action: #selector(onLogout), for: .touchUpInside)
        } else {
            loginView = LoginView(frame: .zero)
            view.addSubview(loginView!)
            loginView?.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.top.equalTo(view.readableContentGuide).offset(30)
            })
            loginView?.confirmButton.addTarget(self, action: #selector(onConfrim(sender:)), for: .touchUpInside)
        }
    }
    
    @objc func onLogout() {
        let alert = UIAlertController(title: nil, message: "确定退出登录?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak self] (action) in
            CanarySwift.shared.logout()
            self?.configView()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func onConfrim(sender: Any) {
        guard let login = loginView else { return }
        let userName = login.userNameField.text
        let password = login.passwordField.text
        if userName?.count == 0 {
            let alert = UIAlertController(title: "", message: "请输入用户名", defaultActionButtonTitle: "确定", tintColor: .blue)
            present(alert, animated: true, completion: nil)
        } else if password?.count == 0 {
            let alert = UIAlertController(title: "", message: "请输入密码", defaultActionButtonTitle: "确定", tintColor: .blue)
            present(alert, animated: true, completion: nil)
        } else {
            let params = ["username": userName ?? "", "password": password?.md5() ?? ""]
            URLRequest.post(with: "/api/user/login", params: params) { [weak self] (result, error) in
                do {
                    if result.code == 0 {
                        let kc = Keychain(server: ServerHostKey, protocolType: .http)
                        try kc.set(result.data?.rawData() ?? Data(), key: UserAuthKey)
                        self?.show(message: "登录成功", success: true)
                        self?.configView()
                    } else {
                        self?.show(message: result.error)
                    }
                } catch {
                    self?.show(message: error.localizedDescription)
                }
            }
        }
    }
    
    func show(message: String?, success: Bool? = false) -> Void {
        if let message = message {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                if success ?? false {
//                    self.navigationController?.popViewController(animated: true)
                }
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    class InfoView: UIView {
        let logouButton = UIButton(type: .custom)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            guard let user = CanarySwift.shared.user() else { return }
            
            let spaceing = 15
            
            let nameLabel = UILabel()
            nameLabel.attributedText = {
                let mattr = NSMutableAttributedString()
                mattr.append(NSAttributedString(string: "名称：", attributes: [.font: UIFont(name: "DINAlternate-Bold", size: 15), .foregroundColor: UIColor(hex: 0x333333)]))
                mattr.append(NSAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor:UIColor(hex: 0xF20000)]))
                return mattr
            }()
            addSubview(nameLabel)
            nameLabel.snp.makeConstraints { (make) in
                make.left.top.equalToSuperview()
                make.right.lessThanOrEqualToSuperview()
            }
            
            let roleLabel = UILabel()
            roleLabel.attributedText = {
                let mattr = NSMutableAttributedString()
                mattr.append(NSAttributedString(string: "角色：", attributes: [.font: UIFont(name: "DINAlternate-Bold", size: 15), .foregroundColor: UIColor(hex: 0x333333)]))
                mattr.append(NSAttributedString(string: user.rolename, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor:UIColor(hex: 0xF20000)]))
                return mattr
            }()
            addSubview(roleLabel)
            roleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(nameLabel.snp.bottom).offset(spaceing)
                make.right.lessThanOrEqualToSuperview()
            }
            
            let appLabel = UILabel()
            appLabel.attributedText = {
                let mattr = NSMutableAttributedString()
                mattr.append(NSAttributedString(string: "应用：", attributes: [.font: UIFont(name: "DINAlternate-Bold", size: 15), .foregroundColor: UIColor(hex: 0x333333)]))
                mattr.append(NSAttributedString(string: user.app?.name ?? "未选择", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor:UIColor(hex: 0xF20000)]))
                return mattr
            }()
            addSubview(appLabel)
            appLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(roleLabel.snp.bottom).offset(spaceing)
                make.right.lessThanOrEqualToSuperview()
            }
            
            logouButton.setTitle("退出", for: .normal)
            logouButton.layer.cornerRadius = 20
            logouButton.backgroundColor = UIColor(hex: 0x4FA5FF)
            addSubview(logouButton)
            logouButton.snp.makeConstraints { (make) in
                make.top.equalTo(appLabel.snp.bottom).offset(30)
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(40)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class LoginView: UIView {
        let userNameField = UITextField()
        let passwordField = UITextField()
        let confirmButton = UIButton(type: .custom)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            userNameField.layer.cornerRadius = 5
            userNameField.backgroundColor = UIColor(hex: 0xF4F5F6)
            userNameField.placeholder = "用户名"
            userNameField.leftViewMode = .always
            userNameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 50))
            addSubview(userNameField)
            userNameField.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(40)
            }
            
            passwordField.cornerRadius = 5
            passwordField.placeholder = "密码"
            passwordField.leftViewMode = .always
            passwordField.isSecureTextEntry = true
            passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 50))
            passwordField.backgroundColor = UIColor(hex: 0xF4F5F6)
            addSubview(passwordField)
            passwordField.snp.makeConstraints { (make) in
                make.size.equalTo(userNameField)
                make.left.equalTo(userNameField)
                make.top.equalTo(userNameField.snp.bottom).offset(30)
            }
            
            confirmButton.layer.cornerRadius = 20
            confirmButton.backgroundColor = UIColor(hex: 0x4FA5FF)
            confirmButton.setTitle("登录", for: .normal)
            addSubview(confirmButton)
            confirmButton.snp.makeConstraints { (make) in
                make.top.equalTo(passwordField.snp.bottom).offset(20)
                make.left.right.equalToSuperview()
                make.height.equalTo(40)
                make.bottom.equalToSuperview()
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
