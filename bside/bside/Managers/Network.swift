//
//  HTTPManager.swift
//  bside
//
//  Created by Justin Hunter on 2/22/23.
//

import Foundation

class NetworkRequests: ObservableObject {
    @Published var tracks: [Music] = []
    @Published var profileData: [Music] = []
    
    func getCatalog() {
        guard let url = URL(string: "https://catalog-prod.hasura.app/v1/graphql") else { fatalError("Missing URL") }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("catalog-prod.hasura.app", forHTTPHeaderField: "authority")
        request.addValue("*/*", forHTTPHeaderField: "accept")
        request.addValue("en-US,en;q=0.9", forHTTPHeaderField: "accept-language")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("production", forHTTPHeaderField: "environment")
        request.addValue("https://beta.catalog.works", forHTTPHeaderField: "origin")
        request.addValue("https://beta.catalog.works/", forHTTPHeaderField: "referer")
        request.addValue("\"Not_A Brand\";v=\"99\", \"Google Chrome\";v=\"109\", \"Chromium\";v=\"109\"", forHTTPHeaderField: "sec-ch-ua")
        request.addValue("?0", forHTTPHeaderField: "sec-ch-ua-mobile")
        request.addValue("\"macOS\"", forHTTPHeaderField: "sec-ch-ua-platform")
        request.addValue("empty", forHTTPHeaderField: "sec-fetch-dest")
        request.addValue("cors", forHTTPHeaderField: "sec-fetch-mode")
        request.addValue("cross-site", forHTTPHeaderField: "sec-fetch-site")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36", forHTTPHeaderField: "user-agent")

        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "{\"query\":\"query GetAllTracksWithNFTIDs($orderBy: [tracks_order_by!] = [{created_at: desc}], $offset: Int = 0, $limit: Int) {\\n  tracks_aggregate(where: {nft_id: {_is_null: false}}) {\\n    aggregate {\\n      count\\n    }\\n  }\\n  tracks(\\n    where: {nft_id: {_is_null: false}, private: {_neq: true}}\\n    order_by: $orderBy\\n    offset: $offset\\n    limit: $limit\\n  ) {\\n    ...TrackFragment\\n  }\\n}\\n\\nfragment TrackFragment on tracks {\\n  id\\n  title\\n  description\\n  nft_id\\n  ipfs_hash_audio\\n  ipfs_hash_lossy_audio\\n  ipfs_hash_lossy_artwork\\n  ipfs_hash_artwork\\n  ipfs_hash_metadata\\n  nft_content_hash\\n  nft_metadata_hash\\n  artist_fee\\n  created_at\\n  duration\\n  price\\n  artist {\\n    id\\n    name\\n    handle\\n  }\\n  track_number\\n  project_title\\n  project_notes\\n  short_url\\n  mime_type\\n  contract_address\\n}\",\"variables\":{\"limit\":20,\"offset\":0,\"orderBy\":{\"created_at\":\"desc\"}},\"operationName\":\"GetAllTracksWithNFTIDs\"}"
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedTracks = try JSONDecoder().decode(MusicResponse.self, from: data)
                        self.tracks = decodedTracks.data.tracks
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
    
    func postListen(track: Music, address: String) {
        print("Address: ", address)
        let currentDateTime = Date().ISO8601Format()
        
        guard let url = URL(string: "http://localhost:3000/mint") else { fatalError("Missing URL") }

        let json: [String: Any] = ["address": address, "title": track.title, "artist": track.artist.name, "description": track.description, "imageHash": track.ipfs_hash_artwork, "date": currentDateTime]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = jsonData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        print("Done!")
//                        let decodedTracks = try JSONDecoder().decode(MusicResponse.self, from: data)
//                        self.tracks = decodedTracks.data.tracks
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
}
