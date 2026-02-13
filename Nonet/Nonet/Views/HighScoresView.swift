//
//  HighScoresView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct HighScoresView: View {
    @ObservedObject var highScoreManager: HighScoreManager
    @State private var selectedDifficulty: DifficultyLevel = .easy
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Difficulty selector
                Picker("Difficulty", selection: $selectedDifficulty) {
                    ForEach(DifficultyLevel.allCases) { difficulty in
                        Text(difficulty.rawValue).tag(difficulty)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // High scores list
                let scores = highScoreManager.getTopScores(for: selectedDifficulty)
                
                if scores.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "trophy")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No scores yet")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text("Complete a \(selectedDifficulty.rawValue) puzzle to set your first score!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(Array(scores.enumerated()), id: \.element.id) { index, score in
                            HighScoreRow(rank: index + 1, score: score)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("High Scores")
        }
    }
}

struct HighScoreRow: View {
    let rank: Int
    let score: HighScore
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            Text("#\(rank)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(rankColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                // Score
                Text("\(score.score) pts")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                // Time and accuracy
                HStack {
                    Label(timeString, systemImage: "clock")
                    Text("•")
                    Text("\(Int(score.accuracy))% accuracy")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                // Date
                Text(dateString)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .blue
        }
    }
    
    private var timeString: String {
        let minutes = Int(score.time) / 60
        let seconds = Int(score.time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: score.date)
    }
}
