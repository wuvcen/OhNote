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

class Note: NSObject {
    
    var id: NSNumber?
    var date: NSDate = {
        var date = NSDate()
        let zone = NSTimeZone.systemTimeZone()
        let interval = zone.secondsFromGMTForDate(date)
        date = date.dateByAddingTimeInterval(NSTimeInterval(interval))
        return date
    }()
    var title: String = ""
    var summary: String = ""
    var html: String = ""
    var link: String = ""
    var images = [UIImage]()
    
    override init() {}
    
    init(id: Int) {
        let note = db.noteWithID(Int64(id))!
        self.id = note.id!
        self.date = note.date
        self.title = note.title
        self.summary = note.summary
        self.link = note.link
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
    
    class func removeAll() {
        for note in all() {
            note.remove()
        }
    }
    
}

// MARK: - File managements.

extension Note {
    
    func loadHtml() {
        
    }
    
    func saveHtml() {
        
    }
    
    func loadImages() {
        
    }
    
    func saveImages() {
        
    }
}