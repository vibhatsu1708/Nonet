//
//  ScoreCalculator.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation

class ScoreCalculator {
    private let basePoints = 100
    private let goldenWindow: TimeInterval = 10.0
    
    // Calculate points using the formula: P = (B × M) + max(0, (T_max - T_spent) / T_max × B)
    func calculateMovePoints(
        difficulty: DifficultyLevel,
        timeSinceLastMove: TimeInterval,
        hasComboStreak: Bool
    ) -> Int {
        let multiplier = difficulty.scoreMultiplier
        let base = Double(basePoints)
        
        // Time bonus calculation
        let timeBonus = max(0, (goldenWindow - timeSinceLastMove) / goldenWindow * base)
        
        // Base calculation
        var points = Int((base * multiplier) + timeBonus)
        
        // Apply combo streak multiplier (1.2x)
        if hasComboStreak {
            points = Int(Double(points) * 1.2)
        }
        
        return points
    }
    
    // Calculate technique bonus (for advanced solving techniques)
    func calculateTechniqueBonus(techniqueLevel: Int) -> Int {
        // Award bonus for complex techniques
        switch techniqueLevel {
        case 3: return 200 // Hard techniques
        case 4: return 500 // Extreme techniques
        case 5: return 1000 // Expert techniques
        default: return 0
        }
    }
    
    // Calculate mistake penalty (escalating)
    func calculateMistakePenalty(mistakeNumber: Int) -> Int {
        switch mistakeNumber {
        case 1: return 50
        case 2: return 100
        default: return 200
        }
    }
    
    // Calculate final score with accuracy multiplier
    func calculateFinalScore(baseScore: Int, mistakeCount: Int) -> Int {
        let multiplier: Double
        switch mistakeCount {
        case 0:
            multiplier = 2.0 // Perfect game
        case 1...2:
            multiplier = 1.2 // Good accuracy
        default:
            multiplier = 1.0 // No bonus
        }
        
        return Int(Double(baseScore) * multiplier)
    }
}
