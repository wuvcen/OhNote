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
    
    var ID: NSNumber?
    var date: NSDate? = NSDate()
    var title: String? = ""
    var summary: String? = ""
    var html: String? = ""
    var link: String? = ""
    var images = [UIImage]()
    
    override init() {}
    
    init(id: Int) {
        let note = db.noteWithID(Int64(id))
        self.ID = note?.ID!
        self.date = note?.date!
        self.title = note?.title!
        self.summary = note?.summary!
        self.link = note?.link
    }
    
    func loadHtml() {
        
    }
    
    func loadImage() {
        
    }
    
    func save() {
        if let _ = self.ID {
            db.updateNote(self)
        } else {
            self.ID = Int(db.insertNote(self))
            print(self.ID!)
        }
    }
    
    func remove() {
        if let _ = self.ID {
            db.deleteNote(self)
        }
    }
    
    class func all() -> [Note] {
        return db.allNotes()
    }
    
}