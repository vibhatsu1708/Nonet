//
//  DifficultySelectionView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct DifficultySelectionView: View {
    let onDifficultySelected: (DifficultyLevel) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Title
                    VStack(spacing: 8) {
                        Text("NONET")
                            .font(.system(size: 48, weight: .black))
                            .foregroundColor(.blue)
                        
                        Text("Choose Your Challenge")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    // Difficulty cards
                    ForEach(DifficultyLevel.allCases) { difficulty in
                        DifficultyCard(
                            difficulty: difficulty,
                            onSelect: {
                                HapticManager.shared.impactFeedback()
                                onDifficultySelected(difficulty)
                            }
                        )
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

struct DifficultyCard: View {
    let difficulty: DifficultyLevel
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(difficulty.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(difficulty.scoreMultiplier, specifier: "%.1f")x")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(difficultyColor)
                }
                
                Text(difficulty.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Image(systemName: "square.grid.3x3")
                    Text("\(difficulty.clueRange.lowerBound)-\(difficulty.clueRange.upperBound) clues")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(difficultyColor, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var difficultyColor: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .blue
        case .hard: return .orange
        case .extreme: return .red
        case .expert: return .purple
        }
    }
}
