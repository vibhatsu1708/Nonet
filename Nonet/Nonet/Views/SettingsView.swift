//
//  SettingsView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var highScoreManager: HighScoreManager
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Game") {
                    HStack {
                        Image(systemName: "gamecontroller.fill")
                            .foregroundColor(.blue)
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Data") {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Reset All High Scores")
                        }
                    }
                }
                
                Section("About") {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Text("Developer")
                        Spacer()
                        Text("Vedant Mistry")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "number.square.fill")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("About Nonet")
                            Text("A challenging Sudoku game with 5 difficulty levels and dynamic scoring")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset High Scores", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    highScoreManager.resetAllScores()
                }
            } message: {
                Text("Are you sure you want to delete all high scores? This action cannot be undone.")
            }
        }
    }
}
