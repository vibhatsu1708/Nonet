//
//  StatusHeaderView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct StatusHeaderView: View {
    @ObservedObject var engine: GameEngine
    @ObservedObject var scoreManager: ScoreManager
    
    init(engine: GameEngine) {
        self.engine = engine
        self.scoreManager = engine.scoreManager
    }
    
    
    var body: some View {
        HStack {
            // Difficulty
            Text(engine.difficulty.rawValue)
                .font(.headline)
                .foregroundColor(.gray)
            
            Spacer()
            
            // Timer
            HStack(spacing: 4) {
                Image(systemName: "clock")
                Text(timeString(time: engine.timerSeconds))
                    .monospacedDigit()
            }
            .font(.headline)
            
            Spacer()
            
            // Score
            VStack {
                Text("Score")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(scoreManager.score)")
                    .font(.title3)
                    .bold()
            }
            
            Spacer()
            
            // Lives
            HStack(spacing: 2) {
                ForEach(0..<3) { i in
                    Image(systemName: i < engine.lives ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
    }
    
    // Convert seconds to MM:SS
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
