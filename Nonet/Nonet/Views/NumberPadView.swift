//
//  NumberPadView.swift
//  Nonet
//
//  Created by NonetAI on 14/02/26.
//

import SwiftUI

struct NumberPadView: View {
    @ObservedObject var engine: GameEngine
    
    var body: some View {
        VStack(spacing: 20) {
            // Controls Row
            HStack(spacing: 30) {
                Button(action: {
                    engine.undo()
                }) {
                    VStack {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.title2)
                        Text("Undo")
                            .font(.caption)
                    }
                    .foregroundColor(.primary)
                }
                
                Button(action: {
                    engine.erase()
                }) {
                    VStack {
                        Image(systemName: "eraser")
                            .font(.title2)
                        Text("Erase")
                            .font(.caption)
                    }
                    .foregroundColor(.primary)
                }
                
                Button(action: {
                    engine.isNotesMode.toggle()
                }) {
                    VStack {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .symbolVariant(engine.isNotesMode ? .fill : .none)
                            .overlay(
                                Circle()
                                    .stroke(Color.blue, lineWidth: engine.isNotesMode ? 2 : 0)
                                    .scaleEffect(1.5)
                            )
                        Text("Notes")
                            .font(.caption)
                    }
                    .foregroundColor(engine.isNotesMode ? .blue : .primary)
                }
                
                // Hint - "Hint Cost vs Logic Reward"
                Button(action: {
                    // TODO: Implement Hint Logic
                    // For now just placement
                }) {
                    VStack {
                        Image(systemName: "lightbulb")
                            .font(.title2)
                        Text("Hint")
                            .font(.caption)
                    }
                    .foregroundColor(.primary)
                }
            }
            
            // Numbers 1-9
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 9), spacing: 10) {
                ForEach(1...9, id: \.self) { num in
                    Button(action: {
                        engine.setNumber(num)
                    }) {
                        Text("\(num)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .opacity(engine.isNumberCompleted(num) ? 0 : 1)
                    .disabled(engine.isNumberCompleted(num))
                }
            }
            .padding(.horizontal)
        }
    }
}
