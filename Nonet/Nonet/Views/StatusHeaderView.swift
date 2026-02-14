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
        VStack(spacing: 6) {
            HStack {
                Text(engine.difficulty.rawValue)
                    .font(.headline)
                    .foregroundColor(.nonetPrimaryTextColor)
                
                Spacer()
                
                // Timer
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(timeString(time: engine.timerSeconds))
                        .monospacedDigit()
                }
                .font(.headline)
                .foregroundColor(.nonetPrimaryTextColor)
            }
            .padding()
            .background(Color.nonetContainer)
            .cornerRadius(15)
            .padding(.horizontal)
            
            HStack {
                Text("\(scoreManager.score)")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.nonetPrimaryTextColor)
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(0..<3) { i in
                        Image(systemName: i < engine.lives ? "heart.fill" : "heart")
                            .foregroundColor(.nonetHeartFillColor)
                    }
                }
            }
            .padding()
            .background(Color.nonetContainer)
            .cornerRadius(15)
            .padding(.horizontal)

        }
    }
    
    // Convert seconds to MM:SS
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ZStack {
        Color.nonetBackground.ignoresSafeArea()
        StatusHeaderView(engine: GameEngine())
    }
}
