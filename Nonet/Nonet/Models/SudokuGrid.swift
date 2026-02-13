//
//  SudokuGrid.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation

class SudokuGrid: ObservableObject {
    @Published var cells: [[SudokuCell]]
    private var solution: [[Int]]
    
    init(puzzle: [[Int?]], solution: [[Int]]) {
        self.solution = solution
        self.cells = puzzle.enumerated().map { row, rowValues in
            rowValues.enumerated().map { col, value in
                SudokuCell(value: value, isFixed: value != nil)
            }
        }
    }
    
    // Update cell value and check if correct
    func updateCell(row: Int, col: Int, value: Int?) -> Bool {
        guard !cells[row][col].isFixed else { return true }
        
        cells[row][col].value = value
        
        // If value is set, check correctness
        if let val = value {
            let isCorrect = (val == solution[row][col])
            cells[row][col].isError = !isCorrect
            return isCorrect
        } else {
            cells[row][col].isError = false
            return true
        }
    }
    
    // Check if a row is complete and correct
    func isRowComplete(_ row: Int) -> Bool {
        for col in 0..<9 {
            guard let value = cells[row][col].value else { return false }
            if value != solution[row][col] { return false }
        }
        return true
    }
    
    // Check if a column is complete and correct
    func isColumnComplete(_ col: Int) -> Bool {
        for row in 0..<9 {
            guard let value = cells[row][col].value else { return false }
            if value != solution[row][col] { return false }
        }
        return true
    }
    
    // Check if a 3x3 box is complete and correct
    func isBoxComplete(boxRow: Int, boxCol: Int) -> Bool {
        let startRow = boxRow * 3
        let startCol = boxCol * 3
        
        for row in startRow..<startRow + 3 {
            for col in startCol..<startCol + 3 {
                guard let value = cells[row][col].value else { return false }
                if value != solution[row][col] { return false }
            }
        }
        return true
    }
    
    // Check if entire grid is complete and correct
    func isGridComplete() -> Bool {
        for row in 0..<9 {
            if !isRowComplete(row) { return false }
        }
        return true
    }
    
    // Highlight cells for animation
    func highlightRow(_ row: Int, highlight: Bool) {
        for col in 0..<9 {
            cells[row][col].isHighlighted = highlight
        }
    }
    
    func highlightColumn(_ col: Int, highlight: Bool) {
        for row in 0..<9 {
            cells[row][col].isHighlighted = highlight
        }
    }
    
    func highlightBox(boxRow: Int, boxCol: Int, highlight: Bool) {
        let startRow = boxRow * 3
        let startCol = boxCol * 3
        
        for row in startRow..<startRow + 3 {
            for col in startCol..<startCol + 3 {
                cells[row][col].isHighlighted = highlight
            }
        }
    }
    
    func highlightAllCells(highlight: Bool) {
        for row in 0..<9 {
            for col in 0..<9 {
                cells[row][col].isHighlighted = highlight
            }
        }
    }
    
    // Get box coordinates for a cell
    func getBoxCoordinates(row: Int, col: Int) -> (boxRow: Int, boxCol: Int) {
        return (row / 3, col / 3)
    }
}
