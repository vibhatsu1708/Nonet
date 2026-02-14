//
//  NumberPadView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct NumberPadView: View {
    @ObservedObject var engine: GameEngine
    
    var body: some View {
        VStack(spacing: 20) {
            // Controls Row
            HStack(spacing: 30) {
                ControlIcon(icon: "arrow.uturn.backward", label: "Undo") {
                    engine.undo()
                }
                
                ControlIcon(icon: "eraser", label: "Erase") {
                    engine.erase()
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
                                    .stroke(Color.nonetErrorCellBgColor, lineWidth: engine.isNotesMode ? 2 : 0)
                                    .scaleEffect(1.5)
                            )
                        Text("Notes")
                            .font(.caption)
                    }
                    .foregroundColor(engine.isNotesMode ? .nonetErrorCellBgColor : .nonetBeige)
                }
                
                ControlIcon(icon: "lightbulb", label: "Hint") {
                    // TODO: Implement Hint Logic
                }
            }
            .padding(.bottom, 10)
            
            // Numbers 1-9
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 9), spacing: 8) {
                ForEach(1...9, id: \.self) { num in
                    Button(action: {
                        engine.setNumber(num)
                    }) {
                        Text("\(num)")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.nonetBeige)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .background(Color.nonetContainer)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.nonetBeige.opacity(0.2), lineWidth: 1)
                            )
                    }
                    .opacity(engine.isNumberCompleted(num) ? 0 : 1)
                    .disabled(engine.isNumberCompleted(num))
                }
            }
            .padding(.horizontal)
        }
    }
}

fileprivate struct ControlIcon: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption)
            }
            .foregroundColor(.nonetBeige)
        }
    }
}

#Preview {
    ZStack {
        Color.nonetBackground.ignoresSafeArea()
        NumberPadView(engine: GameEngine())
    }
}
