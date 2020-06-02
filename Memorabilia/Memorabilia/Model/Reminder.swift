//
//  Reminder.swift
//  Memorabilia
//
//  Created by André Mello Alves on 26/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import AVFoundation

protocol Reminder {
    
    var type: ReminderType { get }
    
    var identifier: String { get set }
    
    var name: String? { get set }
    
}

struct TextReminder: Reminder {
    
    var type: ReminderType {
        .text
    }
    
    var identifier: String
    
    var name: String?
    
}

struct PhotoReminder: Reminder {
    
    var type: ReminderType {
        .photo
    }
    
    var identifier: String
    
    var name: String?
    
    var data: Data?
    
    init(identifier: String, name: String?, url: URL? = nil) {
        self.identifier = identifier
        self.name = name
        
        guard let url = url else { return }
        self.data = try? Data(contentsOf: url)
    }
    
    init(identifier: String, name: String?, data: Data?) {
        self.identifier = identifier
        self.name = name
        self.data = data
    }
    
}

struct VideoReminder: Reminder {
    
    var type: ReminderType {
        .video
    }
    
    var identifier: String
    
    var name: String?
    
    var player: AVPlayer?
    
    var aspectRatio: CGFloat?
    
    init(identifier: String, name: String?, url: URL? = nil) {
        self.identifier = identifier
        self.name = name
        
        guard let url = url else { return }
        self.player = AVPlayer(url: url)
        self.aspectRatio = AVAsset(url: url).aspectRatio
    }
    
    init(identifier: String, name: String?, item: AVPlayerItem?) {
        self.identifier = identifier
        self.name = name
        self.player = AVPlayer(playerItem: item)
        self.aspectRatio = item?.asset.aspectRatio
    }
    
}

struct AudioReminder: Reminder {
    
    var type: ReminderType {
        .audio
    }
    
    var identifier: String
    
    var name: String?
    
    var player: AVAudioPlayer?
    
    init(identifier: String, name: String?, url: URL? = nil) {
        self.identifier = identifier
        self.name = name
        
        guard let url = url else { return }
        self.player = try? AVAudioPlayer(contentsOf: url)
    }
    
    init(identifier: String, name: String?) {
        self.identifier = identifier
        self.name = name
        
        guard let name = name, let url = URL(string: name) else { return }
        self.player = try? AVAudioPlayer(contentsOf: url)
    }
    
}
