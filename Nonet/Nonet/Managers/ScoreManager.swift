//
//  ScoreManager.swift
//  Nonet
//
//  Created by NonetAI on 14/02/26.
//

import Foundation
import SwiftUI

class ScoreManager: ObservableObject {
    @Published var score: Int = 0
    @Published var mistakeCount: Int = 0
    @Published var consecutiveCorrect: Int = 0
    @Published var isLockedOut: Bool = false
    @Published var lockoutTimeRemaining: TimeInterval = 0
    
    // Constants
    private let basePoints: Double = 100.0
    private let timeWindowMax: TimeInterval = 10.0 // "Golden Window"
    private var lastMoveTime: Date = Date()
    private var lockoutTimer: Timer?
    
    // Multipliers
    private var streakMultiplier: Double {
        return consecutiveCorrect >= 5 ? 1.2 : 1.0
    }
    
    // Lockout duration
    private let lockoutDuration: TimeInterval = 30.0
    
    func startGame() {
        score = 0
        mistakeCount = 0
        consecutiveCorrect = 0
        lastMoveTime = Date()
        isLockedOut = false
        lockoutTimeRemaining = 0
    }
    
    func recordCorrectMove(difficulty: Difficulty) {
        let now = Date()
        let timeSpent = now.timeIntervalSince(lastMoveTime)
        
        // P = (B * M) + max(0, (T_max - T_spent)/T_max * B)
        let B = basePoints
        let M = difficulty.baseMultiplier
        
        let timeBonus = max(0, (timeWindowMax - timeSpent) / timeWindowMax * B)
        
        let moveScore = (B * M) + timeBonus
        
        // Apply Streak Multiplier
        let finalPoints = moveScore * streakMultiplier
        
        score += Int(finalPoints)
        
        // Update state
        consecutiveCorrect += 1
        lastMoveTime = now
    }
    
    // Returns true if game over (lives depleted logic handled in GameEngine, but this tracks mistakes for penalties)
    func recordMistake() {
        consecutiveCorrect = 0
        mistakeCount += 1
        
        // 1st Mistake: -50
        // 2nd Mistake: -100
        // 3rd Mistake: -200 + Lockout
        
        var penalty = 0
        switch mistakeCount {
        case 1: penalty = 50
        case 2: penalty = 100
        case 3: 
            penalty = 200
            triggerLockout()
        default: 
            penalty = 200 // Cap at 200 for subsequent mistakes if lives allow
            if mistakeCount % 3 == 0 { triggerLockout() } // Maybe re-trigger lockout?
        }
        
        score = max(0, score - penalty) // Don't go below zero? Prompt didn't specify, assuming 0 floor is safe UI-wise.
    }
    
    func applyPerfectGameBonus() {
        if mistakeCount == 0 {
            score = Int(Double(score) * 2.0)
        } else if mistakeCount <= 2 {
            score = Int(Double(score) * 1.2)
        }
        // 3+ mistakes: 1.0x (no change)
    }
    
    private func triggerLockout() {
        isLockedOut = true
        lockoutTimeRemaining = lockoutDuration
        
        lockoutTimer?.invalidate()
        lockoutTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.lockoutTimeRemaining -= 1
            if self.lockoutTimeRemaining <= 0 {
                self.isLockedOut = false
                self.lockoutTimer?.invalidate()
            }
        }
    }
    
    func resetTimer() {
        lastMoveTime = Date()
    }
}
