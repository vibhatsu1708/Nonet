//
//  GameOverView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct GameOverView: View {
    let isWon: Bool
    let finalScore: Int
    let time: TimeInterval
    let difficulty: DifficultyLevel
    let onNewGame: (DifficultyLevel) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // Result icon
                Image(systemName: isWon ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(isWon ? .green : .red)
                
                // Title
                Text(isWon ? "Puzzle Solved!" : "Game Over")
                    .font(.system(size: 36, weight: .bold))
                
                // Stats
                VStack(spacing: 16) {
                    StatRow(label: "Final Score", value: "\(finalScore)")
                    StatRow(label: "Time", value: timeString)
                    StatRow(label: "Difficulty", value: difficulty.rawValue)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 12) {
                    // Play again same difficulty
                    Button {
                        dismiss()
                        onNewGame(difficulty)
                    } label: {
                        Text("Play Again")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    // Choose new difficulty
                    Button {
                        dismiss()
                    } label: {
                        Text("Change Difficulty")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
    
    private var timeString: String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
        }
    }
}
