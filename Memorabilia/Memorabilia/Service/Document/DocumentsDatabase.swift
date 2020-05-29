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
    
    private func create(folder: Folder) throws {
        let path = documentsPath.appendingPathComponent(folder.name)
        
        if !fileManager.fileExists(atPath: path) {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    public func create(file: String, folder: Folder, data: Data) throws {
        try create(folder: folder)
        
        let filePath = folder.name + "/" + file + folder.fileExtension
        let path = documentsPath.appendingPathComponent(filePath)
        
        fileManager.createFile(atPath: path, contents: data, attributes: nil)
    }
    
    // MARK: Read
    
    public func read(file: String, folder: Folder) throws -> Data {
        let filePath = folder.name + "/" + file + folder.fileExtension
        let path = documentsPath.appendingPathComponent(filePath)
        
        if let content = fileManager.contents(atPath: path) {
            return content
        } else {
            throw DocumentError.notFound
        }
    }
    
    // MARK: Update
    
    // MARK: Delete
    
    public func delete(file: String?, folder: Folder) throws {
        let filePath = folder.name + "/" + (file ?? "") + folder.fileExtension
        let path = documentsPath.appendingPathComponent(filePath)
        
        try fileManager.removeItem(atPath: path)
    }
    
    // MARK: Enumeration
    
    enum Folder {
        
        case experiences
        case snapshots
        case photos
        
        var name: String {
            switch self {
            case .experiences:
                return "Experiences"
            case .snapshots:
                return "Snapshots"
            case .photos:
                return "Photos"
            }
        }
        
        var fileExtension: String {
            switch self {
            case .experiences:
                return ""
            case .snapshots:
                return ""
            case .photos:
                return ""
            }
        }
    }
    
    // MARK: Error
    
    enum DocumentError: Error {
        
        case notFound
        
        var localizedDescription: String {
            switch self {
            case .notFound:
                return "File not found."
            }
        }
    }
    
}
