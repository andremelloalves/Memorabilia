//
//  StudioInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 29/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import PromiseKit

protocol StudioInteractorInput {
    
    // Create

    func createMemory(with worldData: Data, photo: Data)
    
    func createReminder(identifier: String, type: ReminderType, name: String?)

    // Read
    
    func readReminder(identifier: String) -> Reminder?
    
    func readReminders() -> [Reminder]
    
    func readReminderCount() -> Int

    // Update

    // Delete
    
    func deleteReminder(identifier: String)
    
}

protocol StudioInteractorData {
    
    // Data
    
    var db: Database? { get set }
    
    var reminders: [Reminder] { get set }
    
}

class StudioInteractor: StudioInteractorInput, StudioInteractorData {
    
    // MARK: Clean Properties
    
    var presenter: StudioPresenterInput?
    
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
    
    var reminders: [Reminder] = []
    
    // MARK: Initializers
    
    init() {}
    
    deinit {
        db?.stopNotifications(observer: self)
    }
    
    // MARK: Functions
    
    // Create
    
    func createMemory(with worldData: Data, photo: Data) {
        guard let db = db else { return }
        
        firstly {
            db.createMemory(with: worldData, photo: photo)
        }.done { _ in
            print("Memory saved successfully!")
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    func createReminder(identifier: String, type: ReminderType, name: String? = nil) {
        let reminder: Reminder
        
        switch type {
        case .text:
            reminder = TextReminder(identifier: identifier, name: name)
        case .photo:
            reminder = PhotoReminder(identifier: identifier, name: name)
        case .video:
            reminder = VideoReminder(identifier: identifier, name: name)
        case .audio:
            reminder = AudioReminder(identifier: identifier, name: name)
        }
        
        reminders.append(reminder)
    }
    
    // Read
    
    func readReminder(identifier: String) -> Reminder? {
        reminders.first(where: { $0.identifier == identifier })
    }
    
    func readReminders() -> [Reminder] {
        reminders
    }
    
    func readReminderCount() -> Int {
        reminders.count
    }
    
    // Update
    
    // Delete
    
    func deleteReminder(identifier: String) {
        reminders.removeAll(where: { $0.identifier == identifier })
    }
    
}


extension StudioInteractor: DatabaseObserver {
    
    func notify() {
        
    }
    
}
