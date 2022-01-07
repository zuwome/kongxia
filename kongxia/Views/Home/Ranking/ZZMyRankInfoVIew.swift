//
//  ZZMyRankInfoVIew.swift
//  zuwome
//
//  Created by qiming xiao on 2019/5/26.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit
import CoreText

class ZZMyRankInfoVIew: UIView {
    var viewHeight:CGFloat
    var textArr: [String] = []
    var ctFrame: CTFrame?
    init(frame: CGRect, textArr: [String]?) {
        self.viewHeight = frame.size.height
        super.init(frame: frame)
        self.backgroundColor = .white
        if let arr = textArr {
            self.textArr = arr
            createCoreText()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCoreText() {
        
        var attributeStrArr: [NSAttributedString] = []
        
        for text in textArr {
            let tips = "*  " + text + "\n"
            print(tips)
            let tipAttr = NSMutableAttributedString(string: tips)
            tipAttr.addAttributes([NSAttributedString.Key.font: font(13)], range: NSRange(location: 0, length: tips.count))
            tipAttr.addAttributes([NSAttributedString.Key.foregroundColor: rgbColor(63, 58, 58)], range: NSRange(location: 0, length: tips.count))
            tipAttr.addAttributes([NSAttributedString.Key.foregroundColor: rgbColor(244, 203, 7)], range: NSRange(location: 0, length: 1))
            attributeStrArr.append(tipAttr)
        }
        
        guard attributeStrArr.count > 0 else {
            return
        }
        let tipsAttr = NSMutableAttributedString()
        let titleStr = "壕力飙升小攻略: \n"
        let titleAttr = NSMutableAttributedString(string: titleStr)
        titleAttr.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)], range: NSRange(location: 0, length: titleAttr.length))
        titleAttr.addAttributes([NSAttributedString.Key.foregroundColor: rgbColor(63, 58, 58)], range: NSRange(location: 0, length: titleAttr.length))
        tipsAttr.append(titleAttr)
        attributeStrArr.forEach {
            tipsAttr.append($0)
        }
        
        
        let lineSpace = 3
//        var paragraphSpacing = 2
//        let settings: [CTParagraphStyleSetting] =
//            [
//                CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.lineSpacingAdjustment, valueSize:       MemoryLayout<CGFloat>.size, value: &lineSpace),
//                CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.maximumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpace),
//                CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.minimumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpace),
////                CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.paragraphSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &paragraphSpacing)
//        ]
        
//        let paragaraph = CTParagraphStyleCreate(settings, 4)
        let paragaraph = NSMutableParagraphStyle()
        paragaraph.lineSpacing = CGFloat(lineSpace)
        paragaraph.paragraphSpacing = 3
        paragaraph.maximumLineHeight = 18.0
        paragaraph.minimumLineHeight = 18.0
        paragaraph.headIndent = 12
        tipsAttr.addAttributes([NSAttributedString.Key.paragraphStyle: paragaraph], range: NSRange(location: 0, length: tipsAttr.length))
//        let dict = NSMutableDictionary()
//        dict.setObject(paragaraph, forKey: kCTParagraphStyleAttributeName as! NSCopying)
//
//        guard let d = dict as? [NSAttributedString.Key : Any] else {
//            return
//        }
        
//        tipsAttr.addAttributes(d, range: NSRange(location: 0, length: tipsAttr.length))
        
        
        let frameSetter = CTFramesetterCreateWithAttributedString(tipsAttr)
        let restrictSize = CGSize(width: self.width, height: CGFloat(MAXFLOAT))
        let coretextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRange(location: 0, length: 0), nil, restrictSize, nil)
        viewHeight = coretextSize.height
        
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: self.width, height: viewHeight))
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        self.ctFrame = frame

    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext(), let frame = ctFrame else {
            return
        }
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1, y: -1)
        CTFrameDraw(frame, context)
    }
}
