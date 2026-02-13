//
//  DifficultyLevel.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation

enum DifficultyLevel: String, CaseIterable, Identifiable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case extreme = "Extreme"
    case expert = "Expert"
    
    var id: String { rawValue }
    
    // Number of clues (filled cells) to provide
    var clueRange: ClosedRange<Int> {
        switch self {
        case .easy: return 36...45
        case .medium: return 30...35
        case .hard: return 25...29
        case .extreme: return 20...24
        case .expert: return 17...19
        }
    }
    
    // Score multiplier for this difficulty
    var scoreMultiplier: Double {
        switch self {
        case .easy: return 1.0
        case .medium: return 1.5
        case .hard: return 2.0
        case .extreme: return 3.0
        case .expert: return 5.0
        }
    }
    
    var description: String {
        switch self {
        case .easy:
            return "Naked Singles, Hidden Singles"
        case .medium:
            return "Pointing Pairs, Box/Line Reduction"
        case .hard:
            return "Naked/Hidden Pairs & Triples, X-Wings"
        case .extreme:
            return "XY-Wings, Swordfish, Simple Colors"
        case .expert:
            return "AIC, 3D Medusa, Forcing Chains"
        }
    }
}
