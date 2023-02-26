//
//  MusicView.swift
//  bside
//
//  Created by Justin Hunter on 2/21/23.
//

import SwiftUI

struct AuthView: View {
    var network: NetworkRequests
    @State private var showPlayer = false
    @ObservedObject var viewModel = FCLViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.address == nil {
                ZStack {
                    Color(hex: "#FDBB04")
                        .ignoresSafeArea()
                    VStack {
                        HStack {
                            Spacer()
                            Image("sidebsplash")
                                .resizable()
                                .ignoresSafeArea()
                                .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.height/1.6)
                            Spacer()
                        }
                        ZStack {
                            Color(hex: "#000000")
                                .ignoresSafeArea()
                            VStack {
                                Text("DON'T JUST")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .multilineTextAlignment(.center)
                                Text("DISCOVER,")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .multilineTextAlignment(.center)
                                Text("ENGAGE.")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .multilineTextAlignment(.center)
                                Button {
                                    viewModel.authn(usingAccountProof: viewModel.usingAccountProof)
                                } label: {
                                    Label("Sign in", systemImage: "none")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 10)
                                        .frame(width: UIScreen.main.bounds.width/1.2)
                                        .background(LinearGradient.authButton)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
            } else {
                VStack {
                    MusicView(network: network, address: viewModel.address?.hexStringWithPrefix ?? "")
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct AuthView_Previews: PreviewProvider {
//    static let musicVM = MusicViewModel(music: Music.data)
    static var previews: some View {
        let network = NetworkRequests()
//        AuthView(musicVM: musicVM)
        AuthView(network: network)
    }
}
