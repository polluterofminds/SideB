//
//  MusicViewModel.swift
//  tbside
//
//  Created by Justin Hunter on 2/21/23.
//

import Foundation

final class MusicViewModel: ObservableObject {
    private(set) var music: Music
    
    init(music: Music) {
        self.music = music
    }
}

struct Aggregate: Decodable {
    let count: Int
}

struct TracksAggregate: Decodable {
    let aggregate: Aggregate
}

struct DataModel: Decodable {
    let tracks_aggregate: TracksAggregate
    let tracks: [Music]
}

struct Artist: Identifiable, Decodable {
    let id: String
    let name: String
    let handle: String
}
struct Music: Identifiable, Decodable {
    let id: UUID
    let title: String
    let description: String
    let nft_id: String
    let ipfs_hash_audio: String
    let ipfs_hash_lossy_audio: String
    let ipfs_hash_lossy_artwork: String
    let ipfs_hash_artwork: String
    let ipfs_hash_metadata: String
    let nft_content_hash: String
    let nft_metadata_hash: String
    let artist_fee: Float16
    let created_at: String
//    let track_number: Int
    let project_title: String
    let project_notes: String
    let short_url: String
    let mime_type: String
    let contract_address: String
    let artist: Artist
    let duration: TimeInterval
//    static let data = Music(title: "Two Suns", description: "", duration: 70, track: "https://ipfs.io/ipfs/QmUkxiCSJW3LY14UownFB33tYzmFBDAuua9x7eQSJVQP6B?reef.mp3", artist: "Reef Loreto", image: "music")
}

struct MusicResponse: Decodable {
    let data: DataModel
}
