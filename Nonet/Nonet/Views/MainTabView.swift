//
//  MainTabView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var gameManager = GameManager()
    @State private var selectedTab = 0
    @State private var showDifficultySelection = true
    
    var body: some View {
        ZStack {
            // Main tab content
            TabView(selection: $selectedTab) {
                // Play Tab
                if gameManager.gameState.grid != nil {
                    GameView(gameManager: gameManager)
                        .tag(0)
                } else {
                    VStack {
                        Spacer()
                        Button {
                            showDifficultySelection = true
                        } label: {
                            Label("Start New Game", systemImage: "play.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        Spacer()
                    }
                    .tag(0)
                }
                
                // High Scores Tab
                HighScoresView(highScoreManager: gameManager.highScoreManager)
                    .tag(1)
                
                // Settings Tab
                SettingsView(highScoreManager: gameManager.highScoreManager)
                    .tag(2)
            }
            .overlay(alignment: .bottom) {
                CustomTabBar(selectedTab: $selectedTab)
            }
            
            // Difficulty selection overlay
            if showDifficultySelection {
                DifficultySelectionView { difficulty in
                    gameManager.startNewGame(difficulty: difficulty)
                    showDifficultySelection = false
                    selectedTab = 0
                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: showDifficultySelection)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "play.fill",
                title: "Play",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
                HapticManager.shared.selectionFeedback()
            }
            
            TabBarButton(
                icon: "trophy.fill",
                title: "Scores",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
                HapticManager.shared.selectionFeedback()
            }
            
            TabBarButton(
                icon: "gearshape.fill",
                title: "Settings",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
                HapticManager.shared.selectionFeedback()
            }
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .blue : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
