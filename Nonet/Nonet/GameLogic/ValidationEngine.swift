//
//  ValidationEngine.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation

class ValidationEngine {
    // Check if a move is valid according to Sudoku rules
    static func isValidMove(grid: [[SudokuCell]], row: Int, col: Int, value: Int) -> Bool {
        // Check row
        for c in 0..<9 {
            if c != col, let cellValue = grid[row][c].value, cellValue == value {
                return false
            }
        }
        
        // Check column
        for r in 0..<9 {
            if r != row, let cellValue = grid[r][col].value, cellValue == value {
                return false
            }
        }
        
        // Check 3x3 box
        let boxRow = (row / 3) * 3
        let boxCol = (col / 3) * 3
        for r in boxRow..<boxRow + 3 {
            for c in boxCol..<boxCol + 3 {
                if r != row || c != col {
                    if let cellValue = grid[r][c].value, cellValue == value {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    // Check if row has no conflicts
    static func isRowValid(grid: [[SudokuCell]], row: Int) -> Bool {
        var seen = Set<Int>()
        for col in 0..<9 {
            if let value = grid[row][col].value {
                if seen.contains(value) {
                    return false
                }
                seen.insert(value)
            }
        }
        return true
    }
    
    // Check if column has no conflicts
    static func isColumnValid(grid: [[SudokuCell]], col: Int) -> Bool {
        var seen = Set<Int>()
        for row in 0..<9 {
            if let value = grid[row][col].value {
                if seen.contains(value) {
                    return false
                }
                seen.insert(value)
            }
        }
        return true
    }
    
    // Check if 3x3 box has no conflicts
    static func isBoxValid(grid: [[SudokuCell]], boxRow: Int, boxCol: Int) -> Bool {
        var seen = Set<Int>()
        let startRow = boxRow * 3
        let startCol = boxCol * 3
        
        for row in startRow..<startRow + 3 {
            for col in startCol..<startCol + 3 {
                if let value = grid[row][col].value {
                    if seen.contains(value) {
                        return false
                    }
                    seen.insert(value)
                }
            }
        }
        return true
    }
}
