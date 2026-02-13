//
//  ScoreModel.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation

class ScoreModel: ObservableObject {
    @Published var totalScore: Int = 0
    @Published var consecutiveCorrect: Int = 0 // For combo tracking
    @Published var mistakeCount: Int = 0
    @Published var hasComboStreak: Bool = false // 5+ correct in a row
    
    private let basePoints = 100
    private let goldenWindow: TimeInterval = 10.0 // seconds
    
    // Calculate points for a correct entry
    func calculatePoints(difficulty: DifficultyLevel, timeSinceLastMove: TimeInterval) -> Int {
        let multiplier = difficulty.scoreMultiplier
        let base = Double(basePoints)
        
        // Time bonus: faster = more points
        let timeBonus = max(0, (goldenWindow - timeSinceLastMove) / goldenWindow * base)
        
        // Base calculation: (B × M) + time bonus
        var points = Int((base * multiplier) + timeBonus)
        
        // Apply combo streak multiplier if active
        if hasComboStreak {
            points = Int(Double(points) * 1.2)
        }
        
        return points
    }
    
    // Award points for correct entry
    func awardPoints(_ points: Int) {
        totalScore += points
        consecutiveCorrect += 1
        
        // Activate combo streak at 5 correct
        if consecutiveCorrect >= 5 {
            hasComboStreak = true
        }
    }
    
    // Apply penalty for mistake
    func applyMistakePenalty() {
        mistakeCount += 1
        consecutiveCorrect = 0
        hasComboStreak = false
        
        let penalty: Int
        switch mistakeCount {
        case 1:
            penalty = 50
        case 2:
            penalty = 100
        default:
            penalty = 200
        }
        
        totalScore = max(0, totalScore - penalty)
    }
    
    // Calculate final score with perfect game multiplier
    func calculateFinalScore() -> Int {
        let multiplier: Double
        switch mistakeCount {
        case 0:
            multiplier = 2.0 // Perfect game
        case 1...2:
            multiplier = 1.2
        default:
            multiplier = 1.0
        }
        
        return Int(Double(totalScore) * multiplier)
    }
    
    func reset() {
        totalScore = 0
        consecutiveCorrect = 0
        mistakeCount = 0
        hasComboStreak = false
    }
}
