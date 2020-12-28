//
//  ConfigurationItemViewCell.swift
//  Canary
//
//  Created by Rake Yang on 2020/2/23.
//

import Foundation
import SnapKit

class ConfigurationItemViewCell: UITableViewCell {
    let extraLabel = UILabel()
    let selectedBtn = UIButton(type: .custom)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont(name: "DINAlternate-Bold", size: 18)
        textLabel?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12)
        })
        
        detailTextLabel?.font = UIFont(name: "DINCondensed", size: 16)
        detailTextLabel?.textColor = UIColor.orange;
        detailTextLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(textLabel!.snp_bottom).offset(6)
        })
        
        extraLabel.lineBreakMode = .byCharWrapping;
        extraLabel.numberOfLines = 0;
        extraLabel.font = UIFont(name: "Baskerville-Italic", size: 14)
        extraLabel.textColor = UIColor.lightGray
        contentView.addSubview(extraLabel)
        extraLabel.snp.makeConstraints { (make) in
            if let detailTextLabel = detailTextLabel {
                make.left.equalTo(detailTextLabel)
                make.top.equalTo(detailTextLabel.snp_bottom).offset(6)
                make.right.lessThanOrEqualToSuperview().offset(-10)
                make.bottom.equalToSuperview().offset(-5)
            }
        }
        
        // 选中状态
        selectedBtn.isUserInteractionEnabled = false
        selectedBtn.setTitle("✔︎", for: .normal)
        selectedBtn.setTitleColor(UIColor.white, for: .normal)
        selectedBtn.setTitleColor(UIColor(hex: 0x1890ff), for: .selected)
        contentView.addSubview(selectedBtn)
        selectedBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.left.greaterThanOrEqualTo(extraLabel).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        extraLabel.isHidden = extraLabel.text?.count ?? 0 == 0
    }
    
    
    class func heightForObject(obj: String?) -> CGFloat {
        var cellH:CGFloat = 58
        let p = NSMutableParagraphStyle()
        p.lineBreakMode = .byCharWrapping;
        let size = (obj ?? "").nsString.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width-40, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font:UIFont(name: "Baskerville-Italic", size: 14) as Any, .paragraphStyle:p], context: nil)
        if (size.height > 0) {
            cellH += 6+size.height
        }
        cellH += 16
        return cellH;
    }
}
