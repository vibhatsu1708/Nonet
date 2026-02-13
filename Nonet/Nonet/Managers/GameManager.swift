//
//  GameManager.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation
import SwiftUI

class GameManager: ObservableObject {
    @Published var gameState = GameState()
    @Published var scoreModel = ScoreModel()
    @Published var timerManager = TimerManager()
    
    private let scoreCalculator = ScoreCalculator()
    private var lastMoveTime: Date = Date()
    private var totalMoves: Int = 0
    
    let highScoreManager = HighScoreManager()
    
    // Start a new game with selected difficulty
    func startNewGame(difficulty: DifficultyLevel) {
        // Generate puzzle
        let (puzzle, solution) = SudokuGenerator.generate(difficulty: difficulty)
        let grid = SudokuGrid(puzzle: puzzle, solution: solution)
        
        // Reset game state
        gameState.startNewGame(difficulty: difficulty, grid: grid)
        scoreModel.reset()
        timerManager.reset()
        lastMoveTime = Date()
        totalMoves = 0
        
        // Start timer
        timerManager.start()
    }
    
    // Handle cell value update
    func updateCell(row: Int, col: Int, value: Int?) {
        guard let grid = gameState.grid else { return }
        
        // Record previous value for undo
        let previousValue = grid.cells[row][col].value
        gameState.recordMove(row: row, col: col, previousValue: previousValue)
        
        // Update the cell
        let isCorrect = grid.updateCell(row: row, col: col, value: value)
        
        if let newValue = value {
            totalMoves += 1
            
            // Calculate time since last move
            let timeSinceLastMove = Date().timeIntervalSince(lastMoveTime)
            lastMoveTime = Date()
            
            if isCorrect {
                // Award points
                let points = scoreCalculator.calculateMovePoints(
                    difficulty: gameState.difficulty,
                    timeSinceLastMove: timeSinceLastMove,
                    hasComboStreak: scoreModel.hasComboStreak
                )
                scoreModel.awardPoints(points)
                
                // Check for completions and trigger animations
                checkCompletionsAndAnimate(grid: grid, row: row, col: col)
                
                // Check if game is won
                if grid.isGridComplete() {
                    winGame()
                }
            } else {
                // Wrong entry - lose life and haptic feedback
                HapticManager.shared.errorFeedback()
                scoreModel.applyMistakePenalty()
                gameState.loseLife()
            }
        }
    }
    
    // Undo last move
    func undo() {
        guard let action = gameState.undo(),
              let grid = gameState.grid else { return }
        
        _ = grid.updateCell(row: action.row, col: action.col, value: action.previousValue)
        HapticManager.shared.selectionFeedback()
    }
    
    // Check for row/column/box completions
    private func checkCompletionsAndAnimate(grid: SudokuGrid, row: Int, col: Int) {
        // Check row completion
        if grid.isRowComplete(row) {
            HapticManager.shared.successFeedback()
            animateRowCompletion(grid: grid, row: row)
        }
        
        // Check column completion
        if grid.isColumnComplete(col) {
            HapticManager.shared.successFeedback()
            animateColumnCompletion(grid: grid, col: col)
        }
        
        // Check box completion
        let (boxRow, boxCol) = grid.getBoxCoordinates(row: row, col: col)
        if grid.isBoxComplete(boxRow: boxRow, boxCol: boxCol) {
            HapticManager.shared.successFeedback()
            animateBoxCompletion(grid: grid, boxRow: boxRow, boxCol: boxCol)
        }
    }
    
    // Animation for row completion
    private func animateRowCompletion(grid: SudokuGrid, row: Int) {
        grid.highlightRow(row, highlight: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            grid.highlightRow(row, highlight: false)
        }
    }
    
    // Animation for column completion
    private func animateColumnCompletion(grid: SudokuGrid, col: Int) {
        grid.highlightColumn(col, highlight: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            grid.highlightColumn(col, highlight: false)
        }
    }
    
    // Animation for box completion
    private func animateBoxCompletion(grid: SudokuGrid, boxRow: Int, boxCol: Int) {
        grid.highlightBox(boxRow: boxRow, boxCol: boxCol, highlight: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            grid.highlightBox(boxRow: boxRow, boxCol: boxCol, highlight: false)
        }
    }
    
    // Win the game
    private func winGame() {
        guard let grid = gameState.grid else { return }
        
        timerManager.pause()
        
        // Animate entire grid
        grid.highlightAllCells(highlight: true)
        HapticManager.shared.successFeedback()
        
        // Calculate final score
        let finalScore = scoreModel.calculateFinalScore()
        
        // Save high score
        let highScore = HighScore(
            score: finalScore,
            difficulty: gameState.difficulty,
            time: timerManager.elapsedTime,
            mistakeCount: scoreModel.mistakeCount,
            totalMoves: totalMoves
        )
        highScoreManager.addScore(highScore)
        
        // End game
        gameState.endGame(won: true)
        
        // Clear highlight after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            grid.highlightAllCells(highlight: false)
        }
    }
    
    // Pause/Resume game
    func pauseGame() {
        timerManager.pause()
        gameState.pause()
    }
    
    func resumeGame() {
        timerManager.resume()
        gameState.resume()
        lastMoveTime = Date() // Reset move timer to avoid unfair penalties
    }
}
