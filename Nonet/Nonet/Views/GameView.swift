//
//  GameView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct GameView: View {
    let difficulty: Difficulty
    let isResuming: Bool
    
    init(difficulty: Difficulty = .medium, isResuming: Bool = false) {
        self.difficulty = difficulty
        self.isResuming = isResuming
    }
    @StateObject private var engine = GameEngine()
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.scenePhase) var scenePhase
    
    // Flat Background
    private let bgColor = Color.nonetBackground
    
    var body: some View {
        ZStack {
            bgColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                StatusHeaderView(engine: engine)
                
                SudokuGridView(engine: engine)
                    .padding(.horizontal)
                
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
                    .foregroundColor(.nonetBeige)
                }
            }
        }
        .onAppear {
            if isResuming {
                if engine.loadGame() {
                    engine.resumeGame()
                } else {
                    // Fallback if load fails
                    engine.startNewGame(difficulty: difficulty)
                }
            } else if engine.grid.isEmpty {
                 engine.startNewGame(difficulty: difficulty)
            } else {
                 engine.resumeGame()
            }
        }
        .onDisappear {
            engine.pauseGame()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background || newPhase == .inactive {
                engine.saveGame()
            }
        }
        .onReceive(engine.moveMadeSubject) { _ in
            AdsManager.shared.checkAndShowTimedAd()
        }
    }
    
    var gameOverOverlay: some View {
        VStack(spacing: 20) {
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.nonetErrorCellBgColor)
            
            Text("Out of lives!")
                .font(.title2)
                .foregroundColor(.nonetBeige)
            
            Text("Final Score: \(engine.scoreManager.score)")
                .font(.headline)
                .foregroundColor(.nonetTaupe)
            
            Button("Main Menu") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.nonetErrorCellBgColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Try Again") {
                engine.startNewGame(difficulty: difficulty)
            }
            .padding()
            .background(Color.nonetDarkBrown)
            .foregroundColor(.nonetBeige)
            .cornerRadius(10)
        }
        .padding(40)
        .background(Color.nonetBackground) // Solid color, no opacity or gradient
        .cornerRadius(20)
        .shadow(radius: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.nonetBeige.opacity(0.1), lineWidth: 1)
        )
        .onAppear {
            AdsManager.shared.showGameOverInterstitial()
        }
    }
    
    var winOverlay: some View {
        VStack(spacing: 20) {
            Text("Solved!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.nonetBeige)
            
            Text("Difficulty: \(difficulty.rawValue)")
                .foregroundColor(.nonetBeige.opacity(0.8))
            
            Text("Final Score: \(engine.scoreManager.score)")
                .font(.headline)
                .foregroundColor(.nonetTaupe)
             
            Button("Main Menu") {
                saveHighScore()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.nonetErrorCellBgColor)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(40)
        .background(Color.nonetBackground)
        .cornerRadius(20)
        .shadow(radius: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.nonetBeige.opacity(0.1), lineWidth: 1)
        )
        .onAppear {
            Haptics.success()
            AdsManager.shared.showGameOverInterstitial()
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

#Preview {
    GameView()
}
