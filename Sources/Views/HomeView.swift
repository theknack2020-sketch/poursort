import SwiftUI

struct HomeView: View {
    @State private var showGame = false
    @State private var showDaily = false
    @State private var showLevelSelect = false
    @State private var showPro = false
    private let levelManager = LevelManager.shared
    private let store = StoreManager.shared
    private let daily = DailyChallengeManager.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color.pourBackground.ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    // Logo
                    VStack(spacing: 12) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 72))
                            .foregroundStyle(Color.pourPrimary)

                        Text("PourSort")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.pourTextPrimary)

                        Text("Color Sorting Puzzle")
                            .font(.subheadline)
                            .foregroundStyle(Color.pourTextSecondary)
                    }

                    Spacer()

                    // Level info
                    Text("Level \(levelManager.currentLevelNumber)")
                        .font(.title3.weight(.medium).monospacedDigit())
                        .foregroundStyle(Color.pourTextSecondary)

                    // Play button
                    Button {
                        showGame = true
                    } label: {
                        Text("Play")
                            .font(.title2.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .foregroundStyle(.white)
                            .background(Color.pourPrimary, in: RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 40)

                    // Daily challenge
                    Button {
                        showDaily = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                            Text("Daily Challenge")
                            if daily.isCompletedToday {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .foregroundStyle(Color.pourPrimary)
                        .background(Color.pourSurface, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 40)

                    // Bottom row
                    HStack(spacing: 32) {
                        Button("Levels") {
                            showLevelSelect = true
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.pourTextSecondary)

                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.subheadline)
                                .foregroundStyle(Color.pourTextSecondary)
                        }

                        if !store.isPro {
                            Button {
                                showPro = true
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "crown.fill")
                                        .font(.caption)
                                    Text("Pro")
                                }
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Color.pourPrimary)
                            }
                        }
                    }

                    Spacer()
                        .frame(height: 32)
                }
            }
            .navigationDestination(isPresented: $showGame) {
                GameView(levelNumber: levelManager.currentLevelNumber)
            }
            .navigationDestination(isPresented: $showDaily) {
                DailyChallengeView()
            }
            .sheet(isPresented: $showLevelSelect) {
                LevelSelectView { level in
                    levelManager.currentLevelNumber = level
                    showLevelSelect = false
                    showGame = true
                }
            }
            .sheet(isPresented: $showPro) {
                ProUpgradeView()
            }
            .onAppear {
                if UserDefaults.standard.bool(forKey: "ps_auto_play") {
                    UserDefaults.standard.set(false, forKey: "ps_auto_play")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showGame = true
                    }
                }
            }
        }
    }
}
