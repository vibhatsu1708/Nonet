//
//  GameView.swift
//  Nonet
//
//  Created by NonetAI on 14/02/26.
//

import SwiftUI

struct GameView: View {
    let difficulty: Difficulty
    @StateObject private var engine = GameEngine()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                StatusHeaderView(engine: engine)
                
                // Grid
                SudokuGridView(engine: engine)
                    .padding(.horizontal)
                
                // Controls
                NumberPadView(engine: engine)
                
                Spacer()
            }
            .blur(radius: engine.gameState == .lost || engine.gameState == .won ? 5 : 0)
            
            // Game Over Overlay
            if engine.gameState == .lost {
                gameOverOverlay
            }
            
            // Win Overlay
            if engine.gameState == .won {
                winOverlay
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    engine.pauseGame()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
        .onAppear {
            // Only start new game if not already active or if difficulty changed
            // Actually, since StateObject is tied to View lifecycle in NavigationStack used in ContentView,
            // it effectively resets when a new GameView is pushed.
            // But let's be safe.
            if engine.grid.isEmpty {
                 engine.startNewGame(difficulty: difficulty)
            } else {
                 engine.resumeGame()
            }
        }
        .onDisappear {
            engine.pauseGame()
        }
    }
    
    var gameOverOverlay: some View {
        VStack(spacing: 20) {
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            Text("Out of lives!")
                .font(.title2)
            
            Text("Final Score: \(engine.scoreManager.score)")
                .font(.headline)
            
            Button("Main Menu") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Try Again") {
                engine.startNewGame(difficulty: difficulty)
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(40)
        .background(Color(UIColor.systemBackground).opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    var winOverlay: some View {
        VStack(spacing: 20) {
            Text("Solved!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            Text("Difficulty: \(difficulty.rawValue)")
            
            Text("Final Score: \(engine.scoreManager.score)")
                .font(.headline)
             
            Button("Main Menu") {
                saveHighScore()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(40)
        .background(Color(UIColor.systemBackground).opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
        .onAppear {
            Haptics.success()
        }
    }
    
    func saveHighScore() {
        let key = "HighScore_\(difficulty.rawValue)"
        let currentHigh = UserDefaults.standard.integer(forKey: key)
        if engine.scoreManager.score > currentHigh {
            UserDefaults.standard.set(engine.scoreManager.score, forKey: key)
        }
    }
}
