//
//  ZZDateFormatterHelper.swift
//  zuwome
//
//  Created by qiming xiao on 2019/3/11.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

class ZZDateFormatterHelper {
    static let share = ZZDateFormatterHelper()
    lazy var sysFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()
    
    lazy var localFormatter: DateFormatter = {
        let dateFormattered = DateFormatter()
        dateFormattered.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormattered.locale = Locale.current
        dateFormattered.timeZone = TimeZone.current
        return dateFormattered
    }()
    private init() {
        
    }
    
    func locaTime(sysTime: String) -> String? {
        let dateFormatted = sysFormatter.date(from: sysTime)
        if let date = dateFormatted {
            return localFormatter.string(from: date)
        }
        return ""
    }
}

//let dateFormatter = DateFormatter()
//dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//
//let dateFormatted = dateFormatter.date(from: sysTime)
//dateFormattered.dateFormat = "yyyy-MM-dd HH:mm:ss"
//dateFormatter.locale = Locale.current
//dateFormatter.timeZone = TimeZone.current
//if let date = dateFormatted {
//    return dateFormatter.string(from: date)
//}
//return ""
