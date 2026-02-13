//
//  SudokuModel.swift
//  Nonet
//
//  Created by NonetAI on 14/02/26.
//

import Foundation
import SwiftUI

/// Represents a single cell on the Sudoku board
struct SudokuCell: Identifiable, Equatable, Hashable {
    let id = UUID()
    var row: Int
    var col: Int
    var value: Int? // 1-9, or nil if empty
    var isGiven: Bool // True if this number was part of the initial puzzle
    var isError: Bool = false // True if the user entered a wrong number
    var notes: Set<Int> = [] // User pencil marks
    
    // For "Hint" functionality, we might want to know the correct value, 
    // but typically the model shouldn't expose it directly to the view easily.
    // However, for validation, the GameEngine will check against the solved board.
}

/// Represents the diffculty levels of the game
enum Difficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case expert = "Expert"
    case extreme = "Extreme"
    
    var baseMultiplier: Double {
        switch self {
        case .easy: return 1.0
        case .medium: return 1.5
        case .hard: return 2.0
        case .expert: return 5.0 // As per user request: Expert (5x) seems logically higher than Extreme (3x) in their prompt, or maybe they meant Extreme is hardest?
                                 // User Prompt: "Easy (1x), Medium (1.5x), Hard (2x), Extreme (3x), Expert (5x)."
                                 // Usually Extreme is harder than Expert, but I will follow the multiplier order.
        case .extreme: return 3.0
        }
    }
    
    var cluesCount: Int {
        switch self {
        case .easy: return 40 // 36-45
        case .medium: return 32 // 30-35
        case .hard: return 27 // 25-29
        case .extreme: return 22 // 20-24
        case .expert: return 18 // 17-19
        }
    }
    
    var emptyCells: Int {
        return 81 - cluesCount
    }
}

/// Represents the current state of the game
enum GameState {
    case active
    case paused
    case won
    case lost
}
