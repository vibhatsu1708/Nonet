//
//  HighScoreManager.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation

struct HighScore: Codable, Identifiable {
    let id: UUID
    let score: Int
    let difficulty: String
    let time: TimeInterval
    let date: Date
    let accuracy: Double // Percentage of correct moves
    
    init(score: Int, difficulty: DifficultyLevel, time: TimeInterval, mistakeCount: Int, totalMoves: Int) {
        self.id = UUID()
        self.score = score
        self.difficulty = difficulty.rawValue
        self.time = time
        self.date = Date()
        self.accuracy = totalMoves > 0 ? Double(totalMoves - mistakeCount) / Double(totalMoves) * 100 : 0
    }
}

class HighScoreManager: ObservableObject {
    @Published var highScores: [String: [HighScore]] = [:] // Difficulty -> Scores
    
    private let maxScoresPerDifficulty = 10
    private let userDefaultsKey = "NonetHighScores"
    
    init() {
        loadScores()
    }
    
    func addScore(_ score: HighScore) {
        var scores = highScores[score.difficulty] ?? []
        scores.append(score)
        
        // Sort by score descending
        scores.sort { $0.score > $1.score }
        
        // Keep only top scores
        if scores.count > maxScoresPerDifficulty {
            scores = Array(scores.prefix(maxScoresPerDifficulty))
        }
        
        highScores[score.difficulty] = scores
        saveScores()
    }
    
    func getTopScores(for difficulty: DifficultyLevel, limit: Int = 10) -> [HighScore] {
        let scores = highScores[difficulty.rawValue] ?? []
        return Array(scores.prefix(limit))
    }
    
    func resetAllScores() {
        highScores.removeAll()
        saveScores()
    }
    
    private func saveScores() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(highScores)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save high scores: \(error)")
        }
    }
    
    private func loadScores() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            highScores = try decoder.decode([String: [HighScore]].self, from: data)
        } catch {
            print("Failed to load high scores: \(error)")
        }
    }
}
