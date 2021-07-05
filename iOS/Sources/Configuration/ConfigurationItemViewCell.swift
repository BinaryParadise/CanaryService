//
//  ConfigurationItemViewCell.swift
//  Canary
//
//  Created by Rake Yang on 2020/2/23.
//

import Foundation
import SnapKit

class ConfigurationItemViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let extraLabel = UILabel()
    let selectedBtn = UIButton(type: .custom)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont(name: "DINAlternate-Bold", size: 18)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12)
        })
        
        valueLabel.font = UIFont(name: "DINCondensed", size: 16)
        valueLabel.textColor = .orange
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(4)
        })
        
        extraLabel.lineBreakMode = .byCharWrapping;
        extraLabel.numberOfLines = 0;
        extraLabel.font = UIFont(name: "Baskerville-Italic", size: 14)
        extraLabel.textColor = .lightGray
        contentView.addSubview(extraLabel)
        extraLabel.snp.makeConstraints { (make) in
            make.left.equalTo(valueLabel)
            make.bottom.equalToSuperview().offset(-8)
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
            make.left.greaterThanOrEqualTo(valueLabel).offset(10)
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
