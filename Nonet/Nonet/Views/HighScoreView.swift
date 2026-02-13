//
//  HighScoreView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct HighScoreView: View {
    @State private var highScores: [String: Int] = [:]
    
    var body: some View {
        List {
            Section(header: Text("Best Scores")) {
                ForEach(Difficulty.allCases, id: \.self) { loose in
                    HStack {
                        Text(loose.rawValue)
                        Spacer()
                        Text("\(highScores[loose.rawValue] ?? 0)")
                            .bold()
                    }
                }
            }
        }
        .navigationTitle("High Scores")
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
