//
//  MusicItemView.swift
//  bside
//
//  Created by Justin Hunter on 2/24/23.
//

import SwiftUI

struct MusicItemView: View {
    var image: String = ""
    var title: String = ""
    var artist: String = ""
    var body: some View {
        HStack {
            ZStack {
                AsyncImage(
                    url: URL(string: "https://submarine.mypinata.cloud/ipfs/\(image)?pinataGatewayToken=fs2_55f1J0qBWJcDzk2VBQPF45NHdXiYoDIVIwbB3R_66ZsNQsp9SzsoUeQkVzE2"),
                                content: { image in
                                    image.resizable()
                                        .scaledToFit()
                                         
                                },
                                placeholder: {
                                    ProgressView()
                                }
                            )
                Image(systemName: "play.circle.fill")      .font(.system(size: 44))
                    .foregroundColor(.white)
            }
            
            VStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(artist)
                    .font(.body)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
        .frame(width: UIScreen.main.bounds.width, height: 150)
        .background(Color(hex: "#1C1C1E"))
        .cornerRadius(10)
    }
}

struct MusicItemView_Previews: PreviewProvider {
    static var previews: some View {
        let image: String = "QmPD6Mn3r75GTxeCheVhwpDCF5QebjaRozMx9QgmGVaFy2"
        let title: String = "Idea of Her"
        let artist: String = "Slowsie"
        MusicItemView(image: image, title: title, artist: artist)
    }
}
