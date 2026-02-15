//
//  GameEngine.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
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
    
    let moveMadeSubject = PassthroughSubject<Void, Never>()
    
    private var undoStack: [[[SudokuCell]]] = []
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    private let saveKey = "SavedGameData"
    
    // MARK: - Initialization
    
    init() {
        // We don't auto-start new game here anymore, 
        // View will trigger start or resume.
        // But for safe default:
        // startNewGame(difficulty: .medium) 
        // Actually, let's leave it blank or default, view handles it.
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
        
        saveGame() // Initial save
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
        
        pushUndoState()
        
        if isNotesMode {
            toggleNote(number, at: row, col: col)
        } else {
            enterNumber(number, at: row, col: col)
        }
        
        saveGame() // Save on every move
    }
    
    private func enterNumber(_ number: Int, at row: Int, col: Int) {
        let correctValue = solvedGrid[row][col]
        let isCorrect = (number == correctValue)
        
        if isCorrect {
            grid[row][col].value = number
            grid[row][col].isError = false
            grid[row][col].notes = [] 
            
            scoreManager.recordCorrectMove(difficulty: difficulty)
            moveMadeSubject.send()
            
            checkForCompletion()
        } else {
            grid[row][col].value = number
            grid[row][col].isError = true
            
            Haptics.error()
            lives -= 1

            scoreManager.recordMistake()
            moveMadeSubject.send()
            
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
    
    func erase() {
        guard let (row, col) = selectedCell,
              gameState == .active,
              !grid[row][col].isGiven else { return }
        
        pushUndoState()
        
        grid[row][col].value = nil
        grid[row][col].isError = false
        grid[row][col].notes = []
        
        saveGame()
    }
    
    func undo() {
        guard let previousState = undoStack.popLast() else { return }
        grid = previousState
        saveGame()
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
            // Saving on every second is too expensive. 
            // We save on moves, pause, and backgrounding.
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
            saveGame()
        }
    }
    
    func resumeGame() {
        if gameState == .paused {
            gameState = .active
            startTimer()
            scoreManager.resetTimer() // Reset urgency timer so they don't lose points for being away
        }
    }
    
    // MARK: - End Game Logic
    
    private func checkForCompletion() {
        let isComplete = grid.joined().allSatisfy { $0.value == solvedGrid[$0.row][$0.col] }
        
        if isComplete {
            gameState = .won
            stopTimer()
            scoreManager.applyPerfectGameBonus()
            clearSavedGame()
        }
    }
    
    private func gameOver() {
        gameState = .lost
        stopTimer()
        clearSavedGame()
    }
    
    // MARK: - Persistence
    
    struct GameStateData: Codable {
        let grid: [[SudokuCell]]
        let solvedGrid: [[Int]]
        let difficulty: Difficulty
        let gameState: GameState
        let lives: Int
        let timerSeconds: Int
        let scoreState: ScoreManager.ScoreState
    }
    
    func saveGame() {
        let data = GameStateData(
            grid: grid,
            solvedGrid: solvedGrid,
            difficulty: difficulty,
            gameState: gameState,
            lives: lives,
            timerSeconds: timerSeconds,
            scoreState: scoreManager.saveState()
        )
        
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func loadGame() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode(GameStateData.self, from: data) else {
            return false
        }
        
        self.grid = decoded.grid
        self.solvedGrid = decoded.solvedGrid
        self.difficulty = decoded.difficulty
        self.gameState = decoded.gameState == .active ? .paused : decoded.gameState // Auto-pause validation
        self.lives = decoded.lives
        self.timerSeconds = decoded.timerSeconds
        
        self.scoreManager.loadState(decoded.scoreState)
        
        return true
    }
    
    func hasSavedGame() -> Bool {
        return UserDefaults.standard.data(forKey: saveKey) != nil
    }
    
    func clearSavedGame() {
        UserDefaults.standard.removeObject(forKey: saveKey)
    }
    func isNumberCompleted(_ number: Int) -> Bool {
        let count = grid.joined().filter { $0.value == number && !$0.isError }.count
        return count == 9
    }
}
