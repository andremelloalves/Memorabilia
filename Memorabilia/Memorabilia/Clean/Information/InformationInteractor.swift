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
    
    func readInformations()

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
    
    func readInformations() {
        readInformations(shouldUpdate: false)
    }
    
    private func readInformations(shouldUpdate: Bool = false) {
        guard let db = db, let type = type else { return }
        
        firstly {
            db.readInformations(type: type)
        }.get { informations in
            self.informations = informations
        }.map {
            $0.map { InformationEntity.Present(uid: $0.uid, title: $0.title, message: $0.message, photoID: $0.photoID) }
        }.done(on: .global(qos: .userInitiated)) { informations in
            self.presenter?.present(informations: informations, shouldUpdate: shouldUpdate)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    // Update
    
    // Delete
    
}


extension InformationInteractor: DatabaseObserver {
    
    func notify() {
        readInformations(shouldUpdate: true)
    }
    
}
