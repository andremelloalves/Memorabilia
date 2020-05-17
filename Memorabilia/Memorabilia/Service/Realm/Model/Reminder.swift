//
//  Reminder.swift
//  Memorabilia
//
//  Created by André Mello Alves on 26/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import AVFoundation

protocol Reminder {
    
    var identifier: String { get set }
    
    var name: String? { get set }
    
}

struct TextReminder: Reminder {
    
    var identifier: String
    
    var name: String?
    
}

struct PhotoReminder: Reminder {
    
    var identifier: String
    
    var name: String?
    
    var data: Data?
    
    init(identifier: String, name: String?, url: URL?) {
        self.identifier = identifier
        self.name = name
        
        guard let url = url else { return }
        self.data = try? Data(contentsOf: url)
    }
    
}

struct VideoReminder: Reminder {
    
    var identifier: String
    
    var name: String?
    
    var player: AVPlayer?
    
    var aspectRatio: CGFloat?
    
    init(identifier: String, name: String?, url: URL?) {
        self.identifier = identifier
        self.name = name
        
        guard let url = url else { return }
        self.player = AVPlayer(url: url)
        self.aspectRatio = AVAsset(url: url).aspectRatio
    }
    
}

struct AudioReminder: Reminder {
    
    var identifier: String
    
    var name: String?
    
    var player: AVAudioPlayer?
    
    init(identifier: String, name: String?, url: URL?) {
        self.identifier = identifier
        self.name = name
        
        guard let url = url else { return }
        self.player = try? AVAudioPlayer(contentsOf: url)
    }
    
}
