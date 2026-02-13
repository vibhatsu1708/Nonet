//
//  GameState.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation

struct UndoAction {
    let row: Int
    let col: Int
    let previousValue: Int?
}

class GameState: ObservableObject {
    @Published var grid: SudokuGrid?
    @Published var difficulty: DifficultyLevel = .easy
    @Published var lives: Int = 3
    @Published var isGameOver: Bool = false
    @Published var isGameWon: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var isPaused: Bool = false
    
    private var undoStack: [UndoAction] = []
    private let maxUndoHistory = 50
    
    func startNewGame(difficulty: DifficultyLevel, grid: SudokuGrid) {
        self.difficulty = difficulty
        self.grid = grid
        self.lives = 3
        self.isGameOver = false
        self.isGameWon = false
        self.elapsedTime = 0
        self.isPaused = false
        self.undoStack.removeAll()
    }
    
    func recordMove(row: Int, col: Int, previousValue: Int?) {
        let action = UndoAction(row: row, col: col, previousValue: previousValue)
        undoStack.append(action)
        
        // Limit undo history
        if undoStack.count > maxUndoHistory {
            undoStack.removeFirst()
        }
    }
    
    func undo() -> UndoAction? {
        return undoStack.popLast()
    }
    
    func loseLife() {
        lives -= 1
        if lives <= 0 {
            endGame(won: false)
        }
    }
    
    func endGame(won: Bool) {
        isGameWon = won
        isGameOver = true
        isPaused = true
    }
    
    func pause() {
        isPaused = true
    }
    
    func resume() {
        isPaused = false
    }
}
