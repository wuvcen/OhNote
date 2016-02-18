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
    private let date = Expression<String?>("date")
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
            try rowId = db.run(notes.insert(date <- note.date, summary <- note.summary, link <- note.link))
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        print("Insert: \(rowId)")
        return rowId
    }
    
    func deleteNote(note: Note) -> Int {
        var rowsDeleted = -1
        do {
            let table = notes.filter(id == Int64(note.id!.integerValue))
            try rowsDeleted = db.run(table.delete())
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        print("Delete: \(rowsDeleted)")
        return rowsDeleted
    }
    
    func noteWithID(ID: Int64) -> Note? {
        for note in allNotes() {
            if Int64(note.id!.integerValue) == ID {
                return note
            }
        }
        return nil
    }
    
    func updateNote(note: Note) -> Int {
        var rowsUpdated = -1
        do {
            let table = notes.filter(id == Int64(note.id!.integerValue))
            try rowsUpdated = db.run(table.update(date <- note.date, summary <- note.summary, link <- note.link))
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        print("Update: \(rowsUpdated)")
        return rowsUpdated
    }
    
    func allNotes() ->[Note] {
        var outcome = [Note]()
        do {
            for table in try db.prepare(notes.order(id.desc)) {
                let note = Note()
                note.id = Int(table[id]) as NSNumber
                note.date = table[date]!
                note.summary = table[summary]!
                note.link = table[link]!
                outcome.append(note)
            }
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        return outcome
    }
    
    func printAllNotes() {
        for note in allNotes() {
            print("************ id:\(note.id!) ************")
            print("date:\(note.date)")
            print("summary:\(note.summary)")
        }
    }
}
