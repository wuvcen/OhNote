//
//  DBManager.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/16.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import Foundation
import SQLite

class DBManager {
    
    static let sharedManager = DBManager() // singleton
    private var db: Connection! // database
    // notes.table - properties
    private let notes = Table("notes")
    private let id = Expression<Int64>("id")
    private let date = Expression<NSDate?>("date")
    private let title = Expression<String?>("title")
    private let summary = Expression<String?>("summary")
    private let link = Expression<String?>("link")
    
    private init() {
        do {
            // db connection
            try db = Connection(docPath + "/notes.sqlite")
            // create notes.table
            try db.run(notes.create(temporary: false, ifNotExists: true, block: { (t: TableBuilder) -> Void in
                t.column(id, primaryKey: .Autoincrement)
                t.column(date)
                t.column(title)
                t.column(summary)
                t.column(link)
            }))
        } catch let error as NSError {
            print("Database Error: " + error.localizedDescription)
        }
    }
    
    func insertNote(note: Note) -> Int64 {
        var rowId: Int64 = -1
        do {
            try rowId = db.run(notes.insert(date <- note.date!, title <- note.title!, summary <- note.summary!, link <- note.link!))
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        return rowId
    }
    
    func deleteNote(note: Note) -> Int {
        var rowsDeleted = -1
        do {
            let table = notes.filter(id == Int64(note.ID!.integerValue))
            try rowsDeleted = db.run(table.delete())
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        return rowsDeleted
    }
    
    func noteWithID(ID: Int64) -> Note? {
        for note in allNotes() {
            if Int64(note.ID!.integerValue) == ID {
                return note
            }
        }
        return nil
    }
    
    func updateNote(note: Note) -> Int {
        var rowsUpdated = -1
        do {
            let table = notes.filter(id == Int64(note.ID!.integerValue))
            try rowsUpdated = db.run(table.update(date <- note.date!, title <- note.title!, summary <- note.summary!, link <- note.link!))
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        return rowsUpdated
    }
    
    func allNotes() ->[Note] {
        var outcome = [Note]()
        do {
            for table in try db.prepare(notes) {
                let note = Note()
                note.ID = Int(table[id]) as NSNumber
                note.date = table[date]
                note.title = table[title]
                note.summary = table[summary]
                note.link = table[link]
                outcome.append(note)
            }
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        return outcome
    }
    
    func printAllNotes() {
        for note in allNotes() {
            print("************ id:\(note.ID!) ************")
            print("date:\(note.date!)")
            print("title:\(note.title!)")
            print("summary:\(note.summary!)")
        }
    }
}