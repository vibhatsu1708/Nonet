//
//  GameEngine.swift
//  Nonet
//
//  Created by NonetAI on 14/02/26.
//

import Foundation
import SwiftUI
import Combine

class GameEngine: ObservableObject {
    @Published var grid: [[SudokuCell]] = []
    @Published var solvedGrid: [[Int]] = [] // The solution for validation
    @Published var selectedCell: (row: Int, col: Int)?
    @Published var difficulty: Difficulty = .medium
    @Published var gameState: GameState = .active
    @Published var lives: Int = 3
    @Published var timerSeconds: Int = 0
    @Published var isNotesMode: Bool = false
    
    @Published var scoreManager = ScoreManager()
    
    private var undoStack: [[[SudokuCell]]] = []
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        startNewGame(difficulty: .medium)
    }
    
    func startNewGame(difficulty: Difficulty) {
        self.difficulty = difficulty
        let (puzzle, solution) = SudokuGenerator.generatePuzzle(difficulty: difficulty)
        
        self.grid = puzzle.enumerated().map { (rowIndex, row) in
            row.enumerated().map { (colIndex, val) in
                SudokuCell(
                    row: rowIndex,
                    col: colIndex,
                    value: val == 0 ? nil : val,
                    isGiven: val != 0
                )
            }
        }
        self.solvedGrid = solution
        
        self.gameState = .active
        self.lives = 3
        self.timerSeconds = 0
        self.undoStack.removeAll()
        self.scoreManager.startGame()
        self.startTimer()
    }
    
    // MARK: - Game Logic
    
    func selectCell(row: Int, col: Int) {
        guard gameState == .active else { return }
        selectedCell = (row, col)
    }
    
    func setNumber(_ number: Int) {
        guard let (row, col) = selectedCell,
              gameState == .active,
              !grid[row][col].isGiven else { return }
        
        // Push state to undo stack before mutation
        pushUndoState()
        
        if isNotesMode {
            toggleNote(number, at: row, col: col)
        } else {
            enterNumber(number, at: row, col: col)
        }
    }
    
    private func enterNumber(_ number: Int, at row: Int, col: Int) {
        // Correct implementation per prompt:
        // "if correct do nothing (just set it), if wrong, give haptic, mark red."
        // Actually, prompt says: "if correct do nothing, if wrong, give a haptic validation, and mark that number red."
        // BUT also says "when ... correct, perform an animation".
        // Also scoring depends on correctness.
        
        let correctValue = solvedGrid[row][col]
        var isCorrect = (number == correctValue)
        
        if isCorrect {
            grid[row][col].value = number
            grid[row][col].isError = false
            grid[row][col].notes = [] // Clear notes on correct entry
            
            scoreManager.recordCorrectMove(difficulty: difficulty)
            
            // Check for completion
            checkForCompletion()
        } else {
            grid[row][col].value = number
            grid[row][col].isError = true
            
            Haptics.error()
            lives -= 1
            scoreManager.recordMistake()
            
            if lives <= 0 {
                gameOver()
            }
        }
    }
    
    private func toggleNote(_ number: Int, at row: Int, col: Int) {
        if grid[row][col].notes.contains(number) {
            grid[row][col].notes.remove(number)
        } else {
            grid[row][col].notes.insert(number)
        }
    }
    
    func undo() {
        guard let previousState = undoStack.popLast() else { return }
        grid = previousState
    }
    
    private func pushUndoState() {
        undoStack.append(grid)
    }
    
    // MARK: - Timer Logic
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, self.gameState == .active else { return }
            self.timerSeconds += 1
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func pauseGame() {
        if gameState == .active {
            gameState = .paused
            stopTimer()
        }
    }
    
    func resumeGame() {
        if gameState == .paused {
            gameState = .active
            startTimer()
        }
    }
    
    // MARK: - End Game Logic
    
    private func checkForCompletion() {
        // Check if full grid is filled correctly
        let isComplete = grid.joined().allSatisfy { $0.value == solvedGrid[$0.row][$0.col] }
        
        if isComplete {
            gameState = .won
            stopTimer()
            scoreManager.applyPerfectGameBonus() // Assuming perfect game logic handled in ScoreManager
        }
    }
    
    private func gameOver() {
        gameState = .lost
        stopTimer()
    }
}
