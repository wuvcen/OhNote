//
//  FileManager.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/17.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import Foundation

class FileManager {
    static let sharedManager = FileManager() // singleton
    private let fileManager = NSFileManager()
    private init() {}
    
    func createPathForNote(note: Note) {
        var path = docPath as NSString
        path = path.stringByAppendingPathComponent((note.id! as NSNumber).stringValue)
    }
    
    func deletePathForNote(note: Note) {
        
    }
}
