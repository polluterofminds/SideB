//
//  PlayerView.swift
//  bside
//
//  Created by Justin Hunter on 2/21/23.
//

import SwiftUI
import CoreMedia

struct PlayerView: View {
    @EnvironmentObject var audioManager: AudioManager
    var track: Music
    var setShowPlayer: () -> Void
    
    @State private var value: Double = 0.0
    @State private var isEditing: Bool = false
    @State private var isLooping: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    let timer = Timer
        .publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    func togglePlay() {
        audioManager.playPause()
    }
    
    func stopPlayer() {
        audioManager.stop()
        setShowPlayer()
    }
    
    var body: some View {
        ZStack {
            AsyncImage(
                url: URL(string: "https://submarine.mypinata.cloud/ipfs/\(track.ipfs_hash_artwork)?pinataGatewayToken=fs2_55f1J0qBWJcDzk2VBQPF45NHdXiYoDIVIwbB3R_66ZsNQsp9SzsoUeQkVzE2"),
                            content: { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width)
                                    .ignoresSafeArea()
                                     
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )
            
            //  MARK: Blur View
            
            Rectangle()
                .background(.thinMaterial)
                .opacity(0.25)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                //  MARK: Dismiss Button
                HStack {
                    Button {
                        stopPlayer()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                
                //  MARK: Title
                Text(track.title)
                    .font(.title)
                    .foregroundColor(.white)
                
                Spacer()
                
                    VStack(spacing: 5) {
                        //  MARK: Playback Timeline
                        Slider(value: $value, in: 0...track.duration) { editing in
                            isEditing = editing
                            guard let player = audioManager.player else { return }
                            print("time: ", Double(CMTimeGetSeconds(player.currentTime())))
                            if !editing {
                                let myTime = CMTime(seconds: value, preferredTimescale: 60000)
                                player.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero)  { _ in
                                    print("Time after seek: ", Double(CMTimeGetSeconds(player.currentTime())))
                                    value = Double(CMTimeGetSeconds(player.currentTime()))
                                }
                            }
                        }
                            .accentColor(.white)
                        
                        HStack {
                            Text(DateComponentsFormatter.positional.string(from: value) ?? value.formatted() + "S")
                            Spacer()
                            Text(DateComponentsFormatter.positional.string(from: track.duration) ?? track.duration.formatted() + "S")
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                    }
                    
                    //  MARK: Playback Control
                    
                    HStack {
                        //  MARK: Repeat Button
                        PlaybackControlButton(systemName: "repeat") {
                            isLooping = !isLooping
                        }
                        
                        Spacer()
                        
                        //  MARK: Backward Button
                        PlaybackControlButton(systemName: "gobackward.10") {
                            guard let player = audioManager.player else { return }
                            let myTime = CMTime(seconds: value, preferredTimescale: 60000)
                            player.seek(to: (myTime - CMTime(seconds: 10, preferredTimescale: 60000)), toleranceBefore: .zero, toleranceAfter: .zero)  { _ in
                                print("Time after seek: ", Double(CMTimeGetSeconds(player.currentTime())))
                                value = Double(CMTimeGetSeconds(player.currentTime()))
                        }
                        }
                        
                        Spacer()
                        
                        //  MARK: Play/Pause Button
                        PlaybackControlButton(systemName: audioManager.player?.isPlaying ?? true ? "pause.circle.fill" : "play.circle.fill", fontSize: 44) {
                            togglePlay()
                        }
                        
                        Spacer()
                        
                        //  MARK: Forward Button
                        PlaybackControlButton(systemName: "goforward.10") {
                            guard let player = audioManager.player else { return }
                            let myTime = CMTime(seconds: value, preferredTimescale: 60000)
                            player.seek(to: (myTime + CMTime(seconds: 10, preferredTimescale: 60000)), toleranceBefore: .zero, toleranceAfter: .zero)  { _ in
                                print("Time after seek: ", Double(CMTimeGetSeconds(player.currentTime())))
                                value = Double(CMTimeGetSeconds(player.currentTime()))
                            }
                        }
                        
                        Spacer()
                        
                        //  MARK: Stop Button
                        PlaybackControlButton(systemName: "stop.fill") {
                            stopPlayer()
                        }
                    }
                
            }.padding(20)
        }
        .onAppear {
            print(track)
            audioManager.startPlayer(track: "https://submarine.mypinata.cloud/ipfs/\(track.ipfs_hash_audio)?pinataGatewayToken=fs2_55f1J0qBWJcDzk2VBQPF45NHdXiYoDIVIwbB3R_66ZsNQsp9SzsoUeQkVzE2")
        }
        .onReceive(timer) { _ in
            guard let player = audioManager.player, !isEditing else { return }
            value = Double(CMTimeGetSeconds(player.currentTime()))
        }
        .onChange(of: value) { newValue in
            print("\(value)/\(track.duration)")
            if (value + 0.75) >= track.duration, isLooping {
                guard let player = audioManager.player else { return }
                let myTime = CMTime(seconds: 0, preferredTimescale: 60000)
                player.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero)  { _ in
                    print("Time after seek: ", Double(CMTimeGetSeconds(player.currentTime())))
                    value = Double(CMTimeGetSeconds(player.currentTime()))
                }
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static func setShowPlayer() {
        print("change")
    }
    static var previews: some View {
        let artist = Artist(id: "", name: "", handle: "")
        let track = Music(id: UUID(), title: "", description: "", nft_id: "", ipfs_hash_audio: "", ipfs_hash_lossy_audio: "", ipfs_hash_lossy_artwork: "", ipfs_hash_artwork: "", ipfs_hash_metadata: "", nft_content_hash: "", nft_metadata_hash: "", artist_fee: 1.0, created_at: "", project_title: "", project_notes: "", short_url: "", mime_type: "", contract_address: "", artist: artist, duration: 119.00)

        PlayerView(track: track, setShowPlayer: setShowPlayer)
    }
}
