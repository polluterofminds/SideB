//
//  AudioManager.swift
//  bside
//
//  Created by Justin Hunter on 2/21/23.
//

import Foundation
import AVKit
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
final class AudioManager: ObservableObject {
    var player: AVPlayer?
//    @Published private(set) var isPlaying: Bool = false {
//        didSet {
//            print("is playing: ", isPlaying)
//        }
//    }
    
    func startPlayer(track: String) {
        let url = URL(string: track)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVPlayer(url: url!)
            
            player?.play()
//            isPlaying = true
        } catch {
            print("failed to initialize player", error)
        }
    }
    
    func playPause() {
        guard let player = player else {
            print("Instance of audio player not found")
            return
        }
        
        if player.isPlaying {
            player.pause()
//            isPlaying = false
        } else {
            player.play()
//            isPlaying = true
        }
    }
    
    func stop() {
        guard let player = player else {
            return
        }
        
        if player.isPlaying {
            player.pause()
        }
    }
}
