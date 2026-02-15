//
//  HighScoreView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct HighScoreView: View {
    @State private var highScores: [String: Int] = [:]
    
    // Flat Background
    private let bgColor = Color.nonetBackground
    
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            
            VStack {
                Text("High Scores")
                    .font(.blackOps(size: 30))
                    .foregroundColor(.nonetBeige)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(Difficulty.allCases, id: \.self) { diff in
                            HighScoreRow(difficulty: diff, score: highScores[diff.rawValue] ?? 0)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            loadHighScores()
        }
    }
    
    private func loadHighScores() {
        for diff in Difficulty.allCases {
            let key = "HighScore_\(diff.rawValue)"
            highScores[diff.rawValue] = UserDefaults.standard.integer(forKey: key)
        }
    }
}

fileprivate struct HighScoreRow: View {
    let difficulty: Difficulty
    let score: Int
    
    var iconForDifficulty: String {
        switch difficulty {
        case .easy: return "leaf.fill"
        case .medium: return "flame.fill"
        case .hard: return "bolt.fill"
        case .expert: return "star.fill"
        case .extreme: return "crown.fill"
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: iconForDifficulty)
                .font(.title2)
                .foregroundColor(.nonetBeige)
                .frame(width: 40, height: 40)
                .background(Color.nonetBeige.opacity(0.2))
                .clipShape(Circle())
            
            Text(difficulty.rawValue)
                .font(.headline)
                .foregroundColor(.nonetPrimaryText)
                .padding(.leading, 8)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Score")
                    .font(.caption)
                    .foregroundColor(.nonetSecondaryText)
                Text("\(score)")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.nonetBeige)
            }
        }
        .padding()
        .background(Color.nonetContainer)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.nonetBeige.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        HighScoreView()
    }
}
