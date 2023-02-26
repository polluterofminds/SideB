//
//  MusicView.swift
//  bside
//
//  Created by Justin Hunter on 2/21/23.
//

import SwiftUI

let artist = Artist(id: "", name: "", handle: "")
let testTrack = Music(id: UUID(), title: "", description: "", nft_id: "", ipfs_hash_audio: "", ipfs_hash_lossy_audio: "", ipfs_hash_lossy_artwork: "", ipfs_hash_artwork: "", ipfs_hash_metadata: "", nft_content_hash: "", nft_metadata_hash: "", artist_fee: 1.0, created_at: "", project_title: "", project_notes: "", short_url: "", mime_type: "", contract_address: "", artist: artist, duration: 119.00)

struct MusicView: View {
    var network: NetworkRequests
    var address: String = ""
    @State var showPlayer = false
    @State var showProfile = false
    @State var selectedTrack = testTrack
    
    func setShowProfile() {
        showProfile = !showProfile
    }
    
    func setShowPlayer() {
        showPlayer = !showPlayer
    }
    
    var body: some View {
        if showProfile {
            ProfileView(network: network, address: address, setShowProfile: setShowProfile)
        } else if showPlayer {
            MusicDetailView(track: selectedTrack, address: address, network: network, setShowPlayer: setShowPlayer)
        } else {
            ZStack(alignment: .top) {
                Color(hex: "#000000").ignoresSafeArea()
                VStack {
                    TopNavView(address: address, setShowProfile: setShowProfile).padding([.top], 50)
                    SearchView()
                    Text("TRENDING SONGS")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(network.tracks) { track in
                                VStack(spacing: 20) {
                                    Button {
                                        selectedTrack = track
                                        setShowPlayer()
                                    } label: {
                                        MusicItemView(image: track.ipfs_hash_lossy_artwork, title: track.title, artist: track.artist.name)
                                    }
                                }
                                .ignoresSafeArea()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MusicView_Previews: PreviewProvider {
//    static let musicVM = MusicViewModel(music: Music.data)
    static var previews: some View {
        let network = NetworkRequests()
//        MusicView(musicVM: musicVM)
        MusicView(network: network)
    }
}
