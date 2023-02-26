//
//  ProfileView.swift
//  bside
//
//  Created by Justin Hunter on 2/25/23.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel = FCLViewModel()
    var network: NetworkRequests
    var address: String = ""
    var setShowProfile: () -> Void
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "000000").ignoresSafeArea()
            VStack {
                TopNavView(address: address, setShowProfile: setShowProfile).padding([.top], 50)
                Text("PROFILE")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Listens (\(viewModel.nfts.count))")
                    .font(.body)
                    .foregroundColor(.white)
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.nfts, id: \.self) { nft in
                            ZStack {
                                Color(hex: "#1C1C1E")
                                VStack(spacing: 20) {
                                    Button {
                                    
                                    } label: {
                                        Image("smallRecord").resizable()
                                            .frame(width: 100, height: 100)
                                    }
                                }
                                .ignoresSafeArea()
                                .padding()
                            }
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.getNFTIds()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static func setShowProfile() {
        print("change")
    }
    static var previews: some View {
        let network = NetworkRequests()
        let address: String = "0xcaabaae74fe39fd2"
        ProfileView(network: network, address: address, setShowProfile: setShowProfile)
    }
}
