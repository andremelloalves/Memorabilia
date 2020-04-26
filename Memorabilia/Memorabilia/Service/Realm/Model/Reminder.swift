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
    
}

struct VideoReminder: Reminder {
    
    var identifier: String
    
    var name: String?
    
    var player: AVPlayer?
    
    init(identifier: String, name: String?) {
        self.identifier = identifier
        self.name = name
        
        guard let fileName = name else { return }
        guard let url = URL(string: fileName) else { return }
        
        self.player = AVPlayer(url: url)
    }
    
}

struct AudioReminder: Reminder {
    
    var identifier: String
    
    var name: String?
    
    var player: AVAudioPlayer?
    
    init(identifier: String, name: String?) {
        self.identifier = identifier
        self.name = name
        
        guard let fileName = name else { return }
        guard let url = URL(string: fileName) else { return }
        
        self.player = try? AVAudioPlayer(contentsOf: url)
    }
    
}
