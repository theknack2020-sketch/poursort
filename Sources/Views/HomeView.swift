import SwiftUI

struct HomeView: View {
    @State private var showGame = false
    @State private var showLevelSelect = false
    private let levelManager = LevelManager.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color.pourBackground.ignoresSafeArea()

                VStack(spacing: 32) {
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
                            .frame(width: 200, height: 56)
                            .foregroundStyle(.white)
                            .background(Color.pourPrimary, in: RoundedRectangle(cornerRadius: 16))
                    }

                    // Level select
                    Button("Select Level") {
                        showLevelSelect = true
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color.pourPrimary)

                    Spacer()
                        .frame(height: 40)
                }
            }
            .navigationDestination(isPresented: $showGame) {
                GameView(levelNumber: levelManager.currentLevelNumber)
            }
            .sheet(isPresented: $showLevelSelect) {
                LevelSelectView { level in
                    levelManager.currentLevelNumber = level
                    showLevelSelect = false
                    showGame = true
                }
            }
        }
    }
}
