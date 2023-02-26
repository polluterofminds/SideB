//
//  SearchView.swift
//  bside
//
//  Created by Justin Hunter on 2/24/23.
//

import SwiftUI

struct SearchView: View {
    @State private var searchInput: String = ""
    var body: some View {
        VStack {
            TextField(
                    "",
                    text: $searchInput
                )
            .frame(height: 40)
            .foregroundColor(.white)
            .background(
                    ZStack{
                        Color(hex: "#1C1C1E")
                        if searchInput.count == 0 {
                            HStack {
                                Label("Search", systemImage: "magnifyingglass")
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top: 10, leading: 6, bottom: 10, trailing: 6))
                                Spacer()
                          }
                         .frame(maxWidth: .infinity)
                        }
                    }
                )
            .cornerRadius(10)
            ScrollView(.horizontal) {
                HStack {
                    Text("Hip Hop")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(width: 100)
                    .background(Color(hex: "#1C1C1E"))
                    .cornerRadius(20)
                    Text("Rock")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(width: 100)
                    .background(Color(hex: "#1C1C1E"))
                    .cornerRadius(20)
                    Text("House")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(width: 100)
                    .background(Color(hex: "#1C1C1E"))
                    .cornerRadius(20)
                    Text("Electronic")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(width: 100)
                    .background(Color(hex: "#1C1C1E"))
                    .cornerRadius(20)
                    Text("Jazz")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(width: 100)
                    .background(Color(hex: "#1C1C1E"))
                    .cornerRadius(20)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
