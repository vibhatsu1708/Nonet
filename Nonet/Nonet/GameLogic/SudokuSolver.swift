//
//  SudokuSolver.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation

class SudokuSolver {
    // Solve using backtracking algorithm
    static func solve(_ grid: inout [[Int]]) -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if grid[row][col] == 0 {
                    for num in 1...9 {
                        if isValid(grid, row: row, col: col, num: num) {
                            grid[row][col] = num
                            
                            if solve(&grid) {
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
    
    // Check if a number can be placed at position
    static func isValid(_ grid: [[Int]], row: Int, col: Int, num: Int) -> Bool {
        // Check row
        for c in 0..<9 {
            if grid[row][c] == num {
                return false
            }
        }
        
        // Check column
        for r in 0..<9 {
            if grid[r][col] == num {
                return false
            }
        }
        
        // Check 3x3 box
        let boxRow = (row / 3) * 3
        let boxCol = (col / 3) * 3
        for r in boxRow..<boxRow + 3 {
            for c in boxCol..<boxCol + 3 {
                if grid[r][c] == num {
                    return false
                }
            }
        }
        
        return true
    }
    
    // Count number of solutions (to ensure unique solution)
    static func countSolutions(_ grid: [[Int]], limit: Int = 2) -> Int {
        var gridCopy = grid
        return countSolutionsHelper(&gridCopy, limit: limit)
    }
    
    private static func countSolutionsHelper(_ grid: inout [[Int]], limit: Int) -> Int {
        var count = 0
        
        for row in 0..<9 {
            for col in 0..<9 {
                if grid[row][col] == 0 {
                    for num in 1...9 {
                        if isValid(grid, row: row, col: col, num: num) {
                            grid[row][col] = num
                            count += countSolutionsHelper(&grid, limit: limit)
                            grid[row][col] = 0
                            
                            if count >= limit {
                                return count
                            }
                        }
                    }
                    return count
                }
            }
        }
        
        return 1 // Found a solution
    }
}
