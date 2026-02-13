//
//  GameView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameManager: GameManager
    @State private var selectedCell: (row: Int, col: Int)? = nil
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack(spacing: 16) {
            // Top bar: Timer, Lives, Score
            HStack {
                // Timer
                Label(timeString, systemImage: "timer")
                    .font(.headline)
                
                Spacer()
                
                // Lives
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: index < gameManager.gameState.lives ? "heart.fill" : "heart")
                            .foregroundColor(index < gameManager.gameState.lives ? .red : .gray)
                    }
                }
                
                Spacer()
                
                // Score
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Score")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(gameManager.scoreModel.totalScore)")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Combo streak indicator
            if gameManager.scoreModel.hasComboStreak {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("Combo Streak! 1.2x Bonus")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                .padding(.horizontal)
            }
            
            // Sudoku Grid
            if let grid = gameManager.gameState.grid {
                SudokuGridView(grid: grid, selectedCell: $selectedCell)
            }
            
            Spacer()
            
            // Number Pad
            NumberPadView(
                onNumberSelected: { number in
                    if let cell = selectedCell {
                        gameManager.updateCell(row: cell.row, col: cell.col, value: number)
                    }
                },
                onUndo: {
                    gameManager.undo()
                }
            )
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                gameManager.resumeGame()
            case .inactive, .background:
                gameManager.pauseGame()
            @unknown default:
                break
            }
        }
        .sheet(isPresented: $gameManager.gameState.isGameOver) {
            GameOverView(
                isWon: gameManager.gameState.isGameWon,
                finalScore: gameManager.scoreModel.calculateFinalScore(),
                time: gameManager.timerManager.elapsedTime,
                difficulty: gameManager.gameState.difficulty,
                onNewGame: { difficulty in
                    gameManager.startNewGame(difficulty: difficulty)
                }
            )
        }
    }
    
    private var timeString: String {
        let minutes = Int(gameManager.timerManager.elapsedTime) / 60
        let seconds = Int(gameManager.timerManager.elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
