//
//  SwiftUIView.swift
//  bside
//
//  Created by Justin Hunter on 2/24/23.
//

import SwiftUI

struct TopNavView: View {
    @ObservedObject var viewModel = FCLViewModel()
    var address: String = ""
    var setShowProfile: () -> Void
    var body: some View {
        VStack {
            Button {
                setShowProfile()
            } label: {
                HStack {
                    Text("B")
                        .foregroundColor(.black)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .padding()
                        .background(Color(hex: "#F4F4F4"))
                        .clipShape(Circle())
                    Spacer()
                    Button {
                        setShowProfile()
                    } label: {
                        HStack{
                            //  MARK: Need to show profile picture here
    //                        Text("Ox")
    //                            .font(.title2)
    //                            .fontWeight(.heavy)
    //                            .padding()
    //                            .background(Color(hex: "#F4F4F4"))
    //                            .clipShape(Circle())
    //                        Spacer()
                            Text(address)
                                .font(.title2)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding(10)
                                .truncationMode(.middle)
                                .lineLimit(1)
                        }
                        .frame(width: UIScreen.main.bounds.width/1.85)
                        .background(Color(hex: "#1C1C1E"))
                        .cornerRadius(1000)
                    }
                }
            }
            
        }
    }
}

struct TopNavView_Previews: PreviewProvider {
    static func setShowProfile() {
        print("change")
    }
    static var previews: some View {
        let address: String = "0xcaabaae74fe39fd2"
        TopNavView(address: address, setShowProfile: setShowProfile)
    }
}
