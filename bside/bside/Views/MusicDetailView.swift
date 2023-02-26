//
//  PlayerView.swift
//  bside
//
//  Created by Justin Hunter on 2/21/23.
//

import SwiftUI
import CoreMedia

struct MusicDetailView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State private var playerView = true
    var track: Music
    var address: String
    var network: NetworkRequests
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
//        setShowPlayer()
        playerView = true
    }
    
    func backToArtist() {
        setShowPlayer()
    }
    
    var body: some View {
        if playerView {
            ZStack {
                Color(hex: "#000000").ignoresSafeArea()
                VStack {
                    HStack {
                        HStack {
                            Button {
                                backToArtist()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 36))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                    }
                    
                    HStack {
                        VStack {
                            Text(track.title)
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(track.artist.name)
                                .font(.body)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Text("#\(track.nft_id)")
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    ZStack {
                        AsyncImage(
                            url: URL(string: "https://submarine.mypinata.cloud/ipfs/\(track.ipfs_hash_artwork)?pinataGatewayToken=fs2_55f1J0qBWJcDzk2VBQPF45NHdXiYoDIVIwbB3R_66ZsNQsp9SzsoUeQkVzE2"),
                                        content: { image in
                                            image.resizable()
                                                .scaledToFit()
                                                 
                                        },
                                        placeholder: {
                                            ProgressView()
                                        }
                                    )
                        Button {
                            playerView = false
                        } label: {
                            Image(systemName: "play.circle.fill")      .font(.system(size: 64))
                                .foregroundColor(Color(hex: "#DEDEDE"))
                        }
                    }
                    .cornerRadius(10)
                    ZStack {
                        Color(hex: "#1C1C1E")
                        VStack {
                            Text("DETAILS")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .font(.title3)
                            Text(track.description)
                                .foregroundColor(.white)
                                .padding([.top, .leading], 20)
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .cornerRadius(10)
                    .padding(.top, 20)
                }.padding(.top, 40)
            }
        } else {
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
                            ).blur(radius: 20)
                
                //  MARK: Blur View
                
//                Rectangle()
//                    .background(.thinMaterial)
//                    .opacity(0.25)
//                    .ignoresSafeArea()
                
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
                    
                    HStack {
                        VStack {
                            Text(track.title)
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(track.artist.name)
                                .font(.body)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Text("#\(track.nft_id)")
                            .foregroundColor(.white)
                    }
                    ZStack {
                        AsyncImage(
                            url: URL(string: "https://submarine.mypinata.cloud/ipfs/\(track.ipfs_hash_artwork)?pinataGatewayToken=fs2_55f1J0qBWJcDzk2VBQPF45NHdXiYoDIVIwbB3R_66ZsNQsp9SzsoUeQkVzE2"),
                                        content: { image in
                                            image.resizable()
                                                .scaledToFit()
                                                 
                                        },
                                        placeholder: {
                                            ProgressView()
                                        }
                                    )
                    }
                    .cornerRadius(10)
                    
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
                    .padding(.top, 20)
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
                if (value + 0.75) >= track.duration {
                    guard let player = audioManager.player else { return }
                    network.postListen(track: track, address: address )
                    if isLooping {
                        let myTime = CMTime(seconds: 0, preferredTimescale: 60000)
                        player.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero)  { _ in
                            print("Time after seek: ", Double(CMTimeGetSeconds(player.currentTime())))
                            value = Double(CMTimeGetSeconds(player.currentTime()))
                        }
                    }
                }
            }
        }
    }
}

struct MusicDetailView_Previews: PreviewProvider {
    static func setShowPlayer() {
        print("change")
    }
    static var previews: some View {
        let network = NetworkRequests()
        let artist = Artist(id: "ox4456", name: "Slowsie", handle: "slowsie")
        let track = Music(id: UUID(), title: "Idea of Her", description: "\"'studio.\"\r\nwritten and performed by iman europe.\r\nproduced by j marcell.\r\nartwork by shawntel.\r\n\r\nwinner of this auction will receive a vinyl of this record and a handwritten letter from me!\r\n— \r\nlyrics:\r\n\r\nhe was like...\r\n6'5.\r\nbig lips and brown eyes\r\nhis mind remind me of the sunrise\r\nit got brighter by the minute\r\ni'm too caught up to be committed\r\nnow I'm feelin different\r\n‘cause I just wanna race to you\r\nwith skates on\r\ngot me praying you could stay long\r\nI remember when you first hit my peripheral\r\nshould’ve known it would hit me, yo\r\n‘cause I was like\r\noh my\r\nwide eyed and memorized\r\nand I don't ever really get like that\r\ntried to hold it\r\ntried to reel that back\r\nbut the feelings too\r\nstrong for me to kill em\r\nimma need some space from you\r\ngotta go and make some art for you\r\naww shit, you an artist too?\r\nman. it's funny what the heart'll do\r\n\r\ni just wanna know\r\ndo you think of me when you're in the studio?\r\ndo you think of me when...\r\ni just wanna know\r\ndo you think of me when you're in the studio?\r\nwhen you're in the studio.\r\n\r\n‘cause when I'm in this booth,\r\nall I see is you\r\nI'm in my thoughts,\r\nall I think is you\r\nwondering if we speak the same language\r\nwondering if you vibrate on my wavelength\r\nbut we need to stick to being focused\r\nlove is the realest hocus pocus\r\nI ain't got the time\r\niou ain't got the time, no\r\nlater we'll see how it go.\r\n\r\ndo you think of me while making art?\r\nhave I carved my name deep on your heart, boy?\r\ndo you think of me when...\r\nwhen it's late night and you're up grinding?\r\nwhen you're in the studio?", nft_id: "731", ipfs_hash_audio: "QmextcWaQPTwpQj9DkgN26uX8nmdKifphvcoDti4AYw9ve", ipfs_hash_lossy_audio: "QmShFqKMu1aS3PJDm3JBW3hUj7hUX5bNmqQx6Tt8AXsvQ1", ipfs_hash_lossy_artwork: "QmPD6Mn3r75GTxeCheVhwpDCF5QebjaRozMx9QgmGVaFy2", ipfs_hash_artwork: "QmceJqnvX8usLFSavXKH3SmWKBGVVxBP3EBD1CVGdAQXTc", ipfs_hash_metadata: "bafybeie3z5nowzadxixsorgo6k5ko2f22pg26q5rswvzqvsmtksac4g3cm", nft_content_hash: "", nft_metadata_hash: "", artist_fee: 1.0, created_at: "", project_title: "", project_notes: "", short_url: "", mime_type: "", contract_address: "", artist: artist, duration: 119.00)

        MusicDetailView(track: track, address: "", network: network, setShowPlayer: setShowPlayer)
            .environmentObject(AudioManager())
    }
}
