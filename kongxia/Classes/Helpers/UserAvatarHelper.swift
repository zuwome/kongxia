//
//  UserAvatarHelper.swift
//  kongxia
//
//  Created by qiming xiao on 2023/7/1.
//  Copyright © 2023 TimoreYu. All rights reserved.
//

import Foundation

@objc class AvatarHelper: NSObject {
    @objc public static func RemoveDuplicate(str: String, pattern: String) -> String {
        var newStr = str
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let res = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count))
            var didPatternExist = false
            
            for checkingRes in res {
                if didPatternExist {
                    if let range = Range(checkingRes.range, in: str) {
                        newStr.removeSubrange(range)
                    }
                }
                else {
                    didPatternExist = true
                }
            }
            
            return newStr
        } catch {
            return newStr
        }
    }
}
