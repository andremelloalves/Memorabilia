//
//  DocumentsDatabase.swift
//  Memorabilia
//
//  Created by André Mello Alves on 27/11/19.
//  Copyright © 2019 André Mello Alves. All rights reserved.
//

import Foundation

class DocumentsDatabase {
    
    // MARK: Properties
    
    static let db = DocumentsDatabase()
    
    private var fileManager: FileManager
    
    private var documentsPath: NSString
    
    // MARK: Initializers
    
    private init() {
        self.fileManager = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.documentsPath = NSString(string: path)
    }
    
    // MARK: Create
    
    private func createDirectory(folder: Folder) {
        let path = documentsPath.appendingPathComponent(folder.type)
        
        if fileManager.fileExists(atPath: path) {
            print("Directory already exists.")
        } else {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("Directory created successfully.")
            } catch let error {
                print("Directory not created: " + error.localizedDescription)
            }
        }
    }
    
    func create(name: String, folder: Folder, data: Data) -> Bool {
        createDirectory(folder: folder)
        
        let filePath = folder.type + "/" + name + folder.fileExtension
        let path = documentsPath.appendingPathComponent(filePath)
        
        if fileManager.fileExists(atPath: path) {
            delete(folder: folder, name: name)
        }
        
        return fileManager.createFile(atPath: path, contents: data, attributes: nil)
    }
    
    // MARK: Read
    
    func read(name: String, folder: Folder) -> Data? {
        let document = folder.type + "/" + name + folder.fileExtension
        let path = documentsPath.appendingPathComponent(document)
        
        if fileManager.fileExists(atPath: path) {
            return fileManager.contents(atPath: path)
        } else {
            print("Document not found.")
            return nil
        }
    }
    
    // MARK: Update
    
    // MARK: Delete
    
    func delete(folder: Folder, name: String?) {
        var path = documentsPath.appendingPathComponent(folder.type)
        if let name = name {
            path = NSString(string: path).appendingPathComponent(name)
        }
        
        if fileManager.fileExists(atPath: path) {
            do {
                try fileManager.removeItem(atPath: path)
                print("Directory/file deleted successfully.")
            } catch let error {
                print("Directory/file not deleted: " + error.localizedDescription)
            }
        } else {
            print("Directory/file not found.")
        }
    }
    
    enum Folder {
        case user
        case group
        
        var type: String {
            switch self {
            case .user:
                return "UserPhotos"
            case .group:
                return "GroupPhotos"
            }
        }
        
        var fileExtension: String {
            switch self {
            case .user:
                return ""
            case .group:
                return ""
            }
        }
    }
    
}
