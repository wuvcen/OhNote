//
//  Note.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/16.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import Foundation
import UIKit

private let db = DBManager.sharedManager

class Note {

    private(set) var id: Int?
    
    var date: String = {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy年MM月dd日"
        df.locale = NSLocale(localeIdentifier: "zh_CN")
        return df.stringFromDate(NSDate())
    }()
    
    var time: String = {
        let df = NSDateFormatter()
        df.dateFormat = "HH:mm"
        df.locale = NSLocale(localeIdentifier: "zh_CN")
        return df.stringFromDate(NSDate())
    }()
    
    var title: String = ""
    
    var summary: String = ""
    
    var contentData: NSData = NSData()
    
    init() {}
    
    init(id: Int) {
        let note = db.noteWithID(Int64(id))!
        self.id = note.id!
        self.date = note.date
        self.time = note.time
        self.title = note.title
        self.summary = note.summary
        self.contentData = note.contentData
    }
    
    init(id: Int, date: String, time: String, title: String, summary: String, contentData: NSData) {
        self.id = id
        self.date = date
        self.time = time
        self.title = title
        self.summary = summary
        self.contentData = contentData
    }
    
    func save() {
        if let _ = self.id {
            db.updateNote(self)
        } else {
            self.id = Int(db.insertNote(self))
        }
    }
    
    func remove() {
        if let _ = self.id {
            db.deleteNote(self)
        }
    }
    
    class func all() -> [Note] {
        return db.allNotes()
    }
    
}
