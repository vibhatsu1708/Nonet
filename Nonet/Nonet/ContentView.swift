//
//  ContentView.swift
//  Nonet
//
//  Created by NonetAI on 14/02/26.
//

import SwiftUI

struct ContentView: View {
    @State private var hasSavedGame: Bool = false
    @State private var navigateToResume: Bool = false
    
    // We need a dummy engine to check persistence or use a static method?
    // GameEngine.hasSavedGame() is an instance method. 
    // Let's make it static or just create a temp logical check.
    // Ideally GameEngine handles it.
    
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
                
                // Resume Button
                if hasSavedGame {
                    NavigationLink(destination: GameView(isResuming: true), isActive: $navigateToResume) {
                        Button(action: {
                            navigateToResume = true
                        }) {
                            Text("Resume Game")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Text("or start new")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
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
            .onAppear {
                checkSavedGame()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func checkSavedGame() {
        // Quick check without full engine load
        hasSavedGame = UserDefaults.standard.data(forKey: "SavedGameData") != nil
    }
}
