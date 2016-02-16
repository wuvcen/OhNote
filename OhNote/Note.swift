//
//  Note.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/16.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import Foundation

class Note {
    var id: Int64?
    var title: String?
    var date: NSDate?
    var html: String?
    var link: String?
    var images: [UIImage]?
    
    init() {
        self.date = NSDate()
        
    }
}