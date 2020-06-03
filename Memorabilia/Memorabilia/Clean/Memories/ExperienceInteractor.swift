//
//  ExperienceInteractor.swift
//  Memorabilia
//
//  Created by André Mello Alves on 15/03/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import Foundation
import PromiseKit
import Photos

protocol ExperienceInteractorInput {
    
    // Create
    
    func createReminders(_ entities: [ExperienceEntity.Fetch])

    // Read
    
    func readSnapshot()
    
    func readARWorld()
    
    func readReminder(identifier: String) -> Reminder?
    
    func readTransform(identifier: String) -> Transform?
    
    func readVisualReminders()

    // Update

    // Delete
    
}

protocol ExperienceInteractorData {
    
    // Data
    
    var db: Database? { get set }
    
    var memory: Memory? { get set }
    
}

class ExperienceInteractor: ExperienceInteractorInput, ExperienceInteractorData {
    
    // MARK: Clean Properties
    
    var presenter: ExperiencePresenterInput?
    
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
    
    var memory: Memory?
    
    var reminders: [Reminder] = []
    
    var transforms: [Transform] = []
    
    // MARK: Initializers
    
    init() {}
    
    deinit {
        db?.stopNotifications(observer: self)
    }
    
    // MARK: Functions
    
    // Create
    
    func createReminders(_ entities: [ExperienceEntity.Fetch]) {
        for entity in entities {
            createReminder(identifier: entity.identifier, type: entity.type, name: entity.name)
        }
    }
    
    func createReminder(identifier: String, type: ReminderType, name: String?, media: Any? = nil) {
        let reminder: Reminder
        
        switch type {
        case .text:
            reminder = TextReminder(identifier: identifier, name: name)
        case .photo:
            let data = media as? Data
            reminder = PhotoReminder(identifier: identifier, name: name, data: data)
        case .video:
            let playerItem = media as? AVPlayerItem
            reminder = VideoReminder(identifier: identifier, name: name, playerItem: playerItem)
        case .audio:
            reminder = AudioReminder(identifier: identifier, name: name)
        }
        
        reminders.append(reminder)
    }
    
    // Read
    
    func readSnapshot() {
        guard let db = db, let memory = memory else { return }
        
        firstly {
            db.readMemorySnapshot(id: memory.identifier)
        }.done { photo in
            self.presenter?.presentSnapshot(photo)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    func readARWorld() {
        guard let db = db, let memory = memory else { return }
        
        firstly {
            db.readARWorld(id: memory.identifier)
        }.done { world in
            self.presenter?.presentARWorld(world)
        }.then {
            db.readMemoryTransforms(id: memory.identifier)
        }.get { transforms in
            self.transforms = transforms
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    func readReminder(identifier: String) -> Reminder? {
        reminders.first(where: { $0.identifier == identifier })
    }
    
    func readTransform(identifier: String) -> Transform? {
        transforms.first(where: { $0.identifier == identifier })
    }
    
    func readVisualReminders() {
        let photoReminders = reminders.filter({ $0.type == .photo })
        let videoReminders = reminders.filter({ $0.type == .video })
        let visualReminders = photoReminders + videoReminders
        let identifiers = visualReminders.compactMap({ $0.name })
        
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        assets.enumerateObjects { asset, index, stop in
            let reminder = visualReminders[index]
            let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            switch asset.mediaType {
            case .image:
                self.updatePhotoReminder(reminder: reminder, asset: asset, size: size)
            case .video:
                self.updateVideoReminder(reminder: reminder, asset: asset, size: size)
            default:
                break
            }
        }
    }
    
    // Update
    
    func updatePhotoReminder(reminder: Reminder, asset: PHAsset, size: CGSize) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        
        manager.requestImage(for: asset, targetSize: size, contentMode: .default, options: options) { image, info in
            self.deleteReminder(identifier: reminder.identifier)
            self.createReminder(identifier: reminder.identifier, type: reminder.type, name: reminder.name, media: image?.pngData())
            DispatchQueue.main.async {
                self.presenter?.presentReminder(identifier: reminder.identifier)
            }
        }
    }
    
    func updateVideoReminder(reminder: Reminder, asset: PHAsset, size: CGSize) {
        let manager = PHImageManager.default()
        let options = PHVideoRequestOptions()
        manager.requestPlayerItem(forVideo: asset, options: options) { item, info in
            self.deleteReminder(identifier: reminder.identifier)
            self.createReminder(identifier: reminder.identifier, type: reminder.type, name: reminder.name, media: item)
            DispatchQueue.main.async {
                self.presenter?.presentReminder(identifier: reminder.identifier)
            }
        }
    }
    
    // Delete
    
    func deleteReminder(identifier: String) {
        reminders.removeAll(where: { $0.identifier == identifier })
    }
    
}


extension ExperienceInteractor: DatabaseObserver {
    
    func notify() {
        
    }
    
}
