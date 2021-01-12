//
//  UIViewControllerExtensions.swift
//  Canary
//
//  Created by Rake Yang on 2021/1/12.
//

import Foundation

extension UIViewController {
    func show(success: String?) -> Void {
        let alert = UIAlertController(title: "", message: success, defaultActionButtonTitle: "确定", tintColor: .cyan)
        present(alert, animated: true, completion: nil)
    }
    
    func show(faield: String?) -> Void {
        let alert = UIAlertController(title: "", message: faield, defaultActionButtonTitle: "确定", tintColor: .cyan)
        present(alert, animated: true, completion: nil)
    }
}
