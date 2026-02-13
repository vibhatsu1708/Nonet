//
//  NumberPadView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct NumberPadView: View {
    let onNumberSelected: (Int?) -> Void
    let onUndo: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Numbers 1-9
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                ForEach(1...9, id: \.self) { number in
                    Button {
                        HapticManager.shared.impactFeedback(style: .light)
                        onNumberSelected(number)
                    } label: {
                        Text("\(number)")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                
                // Undo button
                Button {
                    HapticManager.shared.impactFeedback(style: .light)
                    onUndo()
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                
                // Clear button
                Button {
                    HapticManager.shared.impactFeedback(style: .light)
                    onNumberSelected(nil)
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
    }
}
