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
private let fm = FileManager.sharedManager

class Note {
    
    var id: NSNumber?
    var date: String = {
        let df = NSDateFormatter()
        //        df.dateFormat = "yyyy-MM-dd HH:mm"
        df.dateFormat = "MM-dd HH:mm"
        df.locale = NSLocale(localeIdentifier: "zh_CN")
        return df.stringFromDate(NSDate())
    }()
    var summary: String = ""
    var html: String = ""
    var link: String = ""
    var images = [UIImage]()
    
    init() {}
    
    init(id: Int) {
        let note = db.noteWithID(Int64(id))!
        self.id = note.id!
        self.date = note.date
        self.summary = note.summary
        self.link = note.link
        self.loadHtml()
    }
    
    func save() {
        if let _ = self.id {
            db.updateNote(self)
        } else {
            self.id = Int(db.insertNote(self))
            self.createDirectory()
        }
        self.saveHtml()
    }
    
    func remove() {
        if let _ = self.id {
            db.deleteNote(self)
            self.removeDirectory()
        }
    }
    
    class func all() -> [Note] {
        return db.allNotes()
    }
    
    class func removeAll() {
        for note in self.all() {
            note.remove()
        }
    }
    
}

// MARK: - File managements.

extension Note {
    
    func createDirectory() {
        fm.createDirectory("\(self.id!)")
    }
    
    func removeDirectory() {
        fm.removeDirectory("\(self.id!)")
    }
    
    func loadHtml() {
        self.html = fm.contentOfFile("index.html", inDir: "\(self.id!)")
    }
    
    func saveHtml() {
        fm.saveContent(self.html, toFile: "index.html", inDir: "\(self.id!)")
    }
    
    func loadImages() {
        
    }
    
    func saveImages() {
        
    }
}