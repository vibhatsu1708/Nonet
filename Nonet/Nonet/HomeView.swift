//
//  HomeView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct HomeView: View {
    @State private var hasSavedGame: Bool = false
    @State private var navigateToResume: Bool = false
    @State private var animateTitle: Bool = false
    
    private let bgColor = Color.nonetBackground
    
    var body: some View {
        NavigationView {
            ZStack {
                bgColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text("NONET")
                            .font(.blackOps(size: 60))
                            .foregroundColor(.nonetBeige)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 50)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 25) {
                            
                            if hasSavedGame {
                                Button(action: {
                                    navigateToResume = true
                                }) {
                                    ResumeGameCard()
                                }
                                .navigationDestination(isPresented: $navigateToResume) {
                                    GameView(isResuming: true)
                                }
                                .padding(.horizontal)
                                
                                Text("or start a new game")
                                    .font(.caption)
                                    .foregroundColor(.nonetSecondaryText.opacity(0.7))
                                    .padding(.top, -10)
                            }
                            
                            VStack(spacing: 0) {
                                let cases = Difficulty.allCases
                                
                                ForEach(0..<cases.count, id: \.self) { index in
                                    let diff = cases[index]
                                    
                                    NavigationLink(destination: GameView(difficulty: diff)) {
                                        DifficultyCard(difficulty: diff, shouldShowBottomSeparator: index == cases.count-1 ? false : true)
                                            .clipShape(
                                                .rect(
                                                    topLeadingRadius: index == 0 ? 20 : 0,
                                                    bottomLeadingRadius: index == cases.count - 1 ? 20 : 0,
                                                    bottomTrailingRadius: index == cases.count - 1 ? 20 : 0,
                                                    topTrailingRadius: index == 0 ? 20 : 0
                                                )
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            NavigationLink(destination: HighScoreView()) {
                                HStack {
                                    Image(systemName: "trophy.fill")
                                        .foregroundColor(.nonetBeige)
                                    Text("High Scores")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.nonetPrimaryText)
                                .padding()
                                .background(Color.nonetContainer)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.nonetBeige.opacity(0.2), lineWidth: 1)
                                )
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                            
                            NativeAdCard()
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                        }
                    }
                }
            }
            .onAppear {
                checkSavedGame()
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.nonetBeige) // Sets backend navigation items color
    }
    
    private func checkSavedGame() {
        hasSavedGame = UserDefaults.standard.data(forKey: "SavedGameData") != nil
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
