//
//  SideBAuthView.swift
//  bside
//
//  Created by Justin Hunter on 2/24/23.
//

import SwiftUI

struct SideBAuthViewTop: View {
    @ObservedObject var viewModel = FCLViewModel()
    var body: some View {
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
    }
}

struct SideBAuthViewTop_Previews: PreviewProvider {
    static var previews: some View {
        SideBAuthViewTop()
    }
}
