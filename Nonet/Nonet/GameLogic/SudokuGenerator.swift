//
//  SudokuGenerator.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation

class SudokuGenerator {
    // Generate a puzzle with specified difficulty
    static func generate(difficulty: DifficultyLevel) -> (puzzle: [[Int?]], solution: [[Int]]) {
        // Generate complete solved grid
        var solution = generateCompleteGrid()
        
        // Create puzzle by removing cells
        let clueCount = difficulty.clueRange.randomElement() ?? difficulty.clueRange.lowerBound
        let puzzle = removeCells(from: solution, targetClues: clueCount)
        
        return (puzzle, solution)
    }
    
    // Generate a complete valid Sudoku grid
    private static func generateCompleteGrid() -> [[Int]] {
        var grid = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        fillGrid(&grid)
        return grid
    }
    
    private static func fillGrid(_ grid: inout [[Int]]) -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if grid[row][col] == 0 {
                    var numbers = Array(1...9).shuffled()
                    
                    for num in numbers {
                        if SudokuSolver.isValid(grid, row: row, col: col, num: num) {
                            grid[row][col] = num
                            
                            if fillGrid(&grid) {
                                return true
                            }
                            
                            grid[row][col] = 0
                        }
                    }
                    return false
                }
            }
        }
        return true
    }
    
    // Remove cells from complete grid to create puzzle
    private static func removeCells(from solution: [[Int]], targetClues: Int) -> [[Int?]] {
        var puzzle: [[Int?]] = solution.map { $0.map { Int?($0) } }
        let totalCells = 81
        let cellsToRemove = totalCells - targetClues
        
        var removed = 0
        var attempts = 0
        let maxAttempts = 100
        
        while removed < cellsToRemove && attempts < maxAttempts {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            
            if puzzle[row][col] != nil {
                let backup = puzzle[row][col]
                puzzle[row][col] = nil
                
                // Create grid for validation
                var testGrid = puzzle.map { row in
                    row.map { $0 ?? 0 }
                }
                
                // Check if still has unique solution
                let solutionCount = SudokuSolver.countSolutions(testGrid, limit: 2)
                
                if solutionCount == 1 {
                    removed += 1
                } else {
                    // Restore if multiple solutions
                    puzzle[row][col] = backup
                }
            }
            
            attempts += 1
        }
        
        return puzzle
    }
}
