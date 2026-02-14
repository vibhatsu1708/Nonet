//
//  ResumeGameCard.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct ResumeGameCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("RESUME GAME")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.9)) // Better contrast on dark red
                Text("Continue Playing")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Image(systemName: "play.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
        .padding(25)
        .background(
            Color.nonetErrorCellBgColor // Solid accent color
        )
        .cornerRadius(20)
    }
}
