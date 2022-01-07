//
//  ZZOrderReportOtherReasonCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZOrderReportOtherReasonCellDelegate: NSObjectProtocol {
    func reasonDidInput(view: ZZOrderReportOtherReasonCell, reason: String?)
}

class ZZOrderReportOtherReasonCell: ZZTableViewCell {
    weak var delegate: ZZOrderReportOtherReasonCellDelegate?
    let maxInputCounts: Int = 100
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = sysFont(14.0)
        textView.delegate = self
        return textView
    }()
    
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel(text: "请输入您遇到的问题",
                            font: sysFont(14),
                            textColor: rgbColor(153, 153, 153))
        
        return label
    }()
    
    lazy var countsLabel: UILabel = {
        let label = UILabel(text: "0/100",
                            font: sysFont(14.0),
                            textColor: rgbColor(102, 102, 102))
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: UITextViewDelegate
extension ZZOrderReportOtherReasonCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        // 显示隐藏placeHolder
        if textView.text.count > 0 {
            placeHolderLabel.isHidden = true
        }
        else {
            placeHolderLabel.isHidden = false
        }
        
        // 统计字数
        let selectedRange = textView.markedTextRange
        var position: UITextPosition? = nil
        if let range = selectedRange  {
            position = textView.position(from: range.start, offset: 0)
        }
        
        if selectedRange != nil && position != nil {
            return
        }
        
        let text = textView.text
        if let text = text {
            if text.count > maxInputCounts {
                let index = text.index(text.startIndex, offsetBy: maxInputCounts)
                let subString = String(text[..<index])
                textView.text = subString
                countsLabel.text = "\(maxInputCounts)/\(maxInputCounts)"
            }
            else {
                countsLabel.text = "\(text.count)/\(maxInputCounts)"
            }
        }
        delegate?.reasonDidInput(view: self, reason: textView.text)
    }
}

// MARK: Layout
extension ZZOrderReportOtherReasonCell {
    func layout() {
        
        self.contentView.addSubview(textView)
        textView.addSubview(placeHolderLabel)
        self.contentView.addSubview(countsLabel)
        
        textView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.contentView)?.offset()(15.0)
            make?.bottom.equalTo()(self.contentView)?.offset()(-15.0)
            make?.left.equalTo()(self.contentView)?.offset()(15.0)
            make?.right.equalTo()(self.contentView)?.offset()(-15.0)
            make?.height.equalTo()(120)
        }
        
        placeHolderLabel.mas_makeConstraints({ (make) in
            make?.top.equalTo()(textView)?.offset()(8)
            make?.left.equalTo()(textView)?.offset()(5)
        })
        
        countsLabel.mas_makeConstraints { (make) in
            make?.right.equalTo()(textView)
            make?.bottom.equalTo()(textView)
        }
    }
}
