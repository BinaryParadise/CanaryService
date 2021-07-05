//
//  UIViewControllerExtensions.swift
//  Canary
//
//  Created by Rake Yang on 2021/1/12.
//

import Foundation

extension UIViewController {
    func show(success: String?) -> Void {
        let alert = UIAlertController(title: nil, message: success, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func show(faield: String?) -> Void {
        let alert = UIAlertController(title: nil, message: faield, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
