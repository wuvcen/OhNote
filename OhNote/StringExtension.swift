//
//  StringExtension.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/25.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import Foundation

extension String {
    
    func length() -> Int {
        return NSString(string: self).length
    }
    
    func substringWithRange(range: NSRange) -> String {
        return NSString(string: self).substringWithRange(range)
    }
}

extension NSString {
    
}