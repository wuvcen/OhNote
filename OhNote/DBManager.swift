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
    // table
    private let notes = Table("notes")
    // columns
    private let id = Expression<Int64>("id")
    private let date = Expression<String>("date")
    private let time = Expression<String>("time")
    private let title = Expression<String>("title")
    private let summary = Expression<String>("summary")
    private let contentData = Expression<NSData>("contentData")
    
    private init() {
        do {
            // db connection
            try db = Connection(docPath + "/notes.sqlite")
            // create notes.table
            try db.run(notes.create(temporary: false, ifNotExists: true,
                block: { (t: TableBuilder) -> Void in
                    t.column(id, primaryKey: .Autoincrement)
                    t.column(date)
                    t.column(time)
                    t.column(title)
                    t.column(summary)
                    t.column(contentData)
                }))
        } catch let error as NSError {
            print("Database Error: " + error.localizedDescription)
        }
    }
    
    func insertNote(note: Note) -> Int64 {
        var rowId: Int64 = -1
        do {
            try rowId = db.run(
                notes.insert(
                    date <- note.date,
                    time <- note.time,
                    title <- note.title,
                    summary <- note.summary,
                    contentData <- note.contentData
                )
            )
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        print("Insert: \(rowId)")
        return rowId
    }
    
    func deleteNote(note: Note) -> Int {
        var rowsDeleted = -1
        do {
            let table = notes.filter(id == Int64(note.id!))
            try rowsDeleted = db.run(table.delete())
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        print("Delete: \(rowsDeleted)")
        return rowsDeleted
    }
    
    func noteWithID(ID: Int64) -> Note? {
        for note in allNotes() {
            if Int64(note.id!) == ID {
                return note
            }
        }
        return nil
    }
    
    func updateNote(note: Note) -> Int {
        var rowsUpdated = -1
        do {
            let table = notes.filter(id == Int64(note.id!))
            try rowsUpdated = db.run(
                table.update(
                    date <- note.date,
                    time <- note.time,
                    title <- note.title,
                    summary <- note.summary,
                    contentData <- note.contentData
                )
            )
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        print("Update: \(rowsUpdated)")
        return rowsUpdated
    }
    
    func allNotes() ->[Note] {
        var outcome = [Note]()
        do {
            for row in try db.prepare(notes.order(id.desc)) {
                outcome.append(
                    Note(
                        id: Int(row[id]),
                        date: row[date],
                        time: row[time],
                        title: row[title],
                        summary: row[summary],
                        contentData: row[contentData]
                    )
                )
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
            print("title:\(note.title)")
        }
    }
}
