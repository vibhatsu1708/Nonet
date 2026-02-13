//
//  ContentView.swift
//  Nonet
//
//  Created by NonetAI on 14/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("NONET")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Text("Sudoku Solver")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // New Game Menu
                VStack(spacing: 15) {
                    Text("New Game")
                        .font(.headline)
                    
                    ForEach(Difficulty.allCases, id: \.self) { diff in
                        NavigationLink(destination: GameView(difficulty: diff)) {
                            Text(diff.rawValue)
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                NavigationLink(destination: HighScoreView()) {
                    Text("High Scores")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationViewStyle(.stack)
    }
}
