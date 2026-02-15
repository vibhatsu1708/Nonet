//
//  SudokuGenerator.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation

class SudokuGenerator {
    // 9x9 Grid
    // We use a 1D array of size 81 for efficiency, or 2D [9][9]. 2D is often easier to reason about.
    // Let's use 2D Int array where 0 means empty.
    
    /// Generates a new puzzle with the specified number of clues (81 - emptyCells)
    /// Returns: (puzzle: [[Int]], solution: [[Int]])
    static func generatePuzzle(difficulty: Difficulty) -> ([[Int]], [[Int]]) {
        var grid = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        
        // 1. Fill diagonal 3x3 boxes (independent of each other)
        fillDiagonalBoxes(grid: &grid)
        
        // 2. Fill remaining blocks using backtracking
        _ = solve(grid: &grid)
        
        // This 'grid' is now the Solution
        let solution = grid
        
        // 3. Remove digits to make a puzzle
        removeDigits(grid: &grid, count: difficulty.emptyCells)
        
        return (grid, solution)
    }
    
    // MARK: - Generation Helpers
    
    private static func fillDiagonalBoxes(grid: inout [[Int]]) {
        for i in stride(from: 0, to: 9, by: 3) {
            fillBox(grid: &grid, rowStart: i, colStart: i)
        }
    }
    
    private static func fillBox(grid: inout [[Int]], rowStart: Int, colStart: Int) {
        var num: Int
        for i in 0..<3 {
            for j in 0..<3 {
                repeat {
                    num = Int.random(in: 1...9)
                } while !isSafeInBox(grid: grid, rowStart: rowStart, colStart: colStart, num: num)
                
                grid[rowStart + i][colStart + j] = num
            }
        }
    }
    
    private static func isSafeInBox(grid: [[Int]], rowStart: Int, colStart: Int, num: Int) -> Bool {
        for i in 0..<3 {
            for j in 0..<3 {
                if grid[rowStart + i][colStart + j] == num {
                    return false
                }
            }
        }
        return true
    }
    
    private static func solve(grid: inout [[Int]]) -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if grid[row][col] == 0 {
                    for num in 1...9 {
                        if isSafe(grid: grid, row: row, col: col, num: num) {
                            grid[row][col] = num
                            
                            if solve(grid: &grid) {
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
    
    private static func isSafe(grid: [[Int]], row: Int, col: Int, num: Int) -> Bool {
        // Check Row
        for x in 0..<9 {
            if grid[row][x] == num {
                return false
            }
        }
        
        // Check Col
        for x in 0..<9 {
            if grid[x][col] == num {
                return false
            }
        }
        
        // Check 3x3 Box
        let startRow = row - row % 3
        let startCol = col - col % 3
        for i in 0..<3 {
            for j in 0..<3 {
                if grid[i + startRow][j + startCol] == num {
                    return false
                }
            }
        }
        
        return true
    }
    
    private static func removeDigits(grid: inout [[Int]], count: Int) {
        var count = count
        while count > 0 {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            
            if grid[row][col] != 0 {
                grid[row][col] = 0
                count -= 1
            }
        }
    }
}
