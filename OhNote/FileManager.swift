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
    private let fm = NSFileManager()
    private init() {}
    
    func createDirectory(inDir: String) {
        let path = docPath + "/" + inDir
        do {
            try fm.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
    }
    
    func removeDirectory(inDir: String) {
        let path = docPath + "/" + inDir
        do {
            try fm.removeItemAtPath(path)
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
    }
    
    func saveContent(content: String, toFile: String, inDir:String) {
        let path = docPath + "/" + inDir + "/" + toFile
        do {
            try content.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
    }
    
    func contentOfFile(fromFile: String, inDir: String) -> String {
        let path = docPath + "/" + inDir + "/" + fromFile
        var content = ""
        do {
            try content = String(contentsOfFile: path)
        } catch let error as NSError {
            print(__FUNCTION__ + error.localizedDescription)
        }
        return content
    }
    
}
