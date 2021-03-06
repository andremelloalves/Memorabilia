//
//  InformationInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 24/05/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import PromiseKit

protocol InformationInteractorInput {
    
    // Create

    // Read
    
    func read()

    // Update

    // Delete
    
}

protocol InformationInteractorData {
    
    // Data
    
    var db: Database? { get set }
    
    var informations: [Information]? { get }
    
    var type: InformationType? { get set }
    
}

class InformationInteractor: InformationInteractorInput, InformationInteractorData {
    
    // MARK: Clean Properties
    
    var presenter: InformationPresenterInput?
    
    // MARK: Properties
    
    var uid: String = UUID().uuidString
    
    var db: Database? {
        willSet {
            db?.stopNotifications(observer: self)
        }
        didSet {
            db?.startNotifications(observer: self)
        }
    }
    
    var informations: [Information]?
    
    var type: InformationType?
    
    // MARK: Initializers
    
    init() {}
    
    deinit {
        db?.stopNotifications(observer: self)
    }
    
    // MARK: Functions
    
    // Create
    
    // Read
    
    func read() {
        guard let db = db, let type = type else { return }
        
        var types: [InformationType] = [type]
        switch type {
        case .create, .memories, .settings:
            types.append(.app)
        default:
            break
        }
        
        firstly {
            db.readInformations(of: types)
        }.get { informations in
            self.informations = informations
        }.map {
            $0.map { InformationEntity.Present(uid: $0.identifier, title: $0.title, message: $0.message, photoID: $0.photoID) }
        }.done(on: .global(qos: .userInitiated)) { informations in
            self.presenter?.present(informations, shouldUpdate: false)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    // Update
    
    // Delete
    
}


extension InformationInteractor: DatabaseObserver {
    
    func notify() {
        
    }
    
}
