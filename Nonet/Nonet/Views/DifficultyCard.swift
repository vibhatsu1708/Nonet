//
//  DifficultyCard.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct DifficultyCard: View {
    let difficulty: Difficulty
    let shouldShowBottomSeparator: Bool
    
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
                .padding(.leading, 10)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.nonetSecondaryText)
        }
        .padding()
        .background(Color.nonetContainer)
        .overlay(alignment: .bottom) {
            if shouldShowBottomSeparator {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.nonetSeparatorColor)
            }
        }
    }
}
