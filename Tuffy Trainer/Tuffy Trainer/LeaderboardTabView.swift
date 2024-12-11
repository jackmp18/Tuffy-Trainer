//
//  LeaderboardView.swift
//  Tuffy Trainer
//
//  Created by John Michael Lott on 12/10/24.
//

import SwiftUI

struct LeaderboardUser: Codable, Identifiable {
    let id : Int
    let createdAt: String
    let username: String
    let count: Int
}

class LeaderboardViewModel: ObservableObject {
    
    var mockData = [
        LeaderboardUser(id: 1 , createdAt: "", username: "Sam S", count: 500),
        LeaderboardUser(id: 2 , createdAt: "", username: "Frank D", count: 435),
        LeaderboardUser(id: 3 , createdAt: "", username: "Abe L", count: 225),
        LeaderboardUser(id: 4 , createdAt: "", username: "Patrick M", count: 225),
        LeaderboardUser(id: 5 , createdAt: "", username: "Juan Carlos", count: 225),
        LeaderboardUser(id: 6, createdAt: "", username: "Sally Mae", count: 225),
        LeaderboardUser(id: 7 , createdAt: "", username: "Xander L", count: 225),
        LeaderboardUser(id: 8 , createdAt: "", username: "Noserat S", count: 225),
        LeaderboardUser(id: 9 , createdAt: "", username: "John L", count: 225),
        LeaderboardUser(id: 10 , createdAt: "", username: "John L", count: 225),
    ]
}

struct LeaderboardView: View {
    @StateObject var viewModel = LeaderboardViewModel()
    @State var doneButton = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .bold()
            
            HStack {
                Text("Name")
                    .bold()
                
                Spacer()
                
                Text("Weight Max")
                    .bold()
            }
            .padding()
            
            LazyVStack(spacing: 24) {
                ForEach(viewModel.mockData) { person in
                    HStack {
                        Text("\(person.id).")
                        
                        Text(person.username)
                        
                        Spacer()
                        
                        Text("\(person.count)")
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            
            Button {
                if doneButton {
                    dismiss()
                }
            } label: {
                Text("Done")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(maxHeight: .infinity,alignment: .top)
    }
}

#Preview {
    LeaderboardView()
}
