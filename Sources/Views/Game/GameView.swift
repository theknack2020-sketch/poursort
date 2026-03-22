import SwiftUI

struct GameView: View {
    let levelNumber: Int
    @State private var engine = GameEngine()
    @State private var showWin = false
    @State private var showStuck = false
    @State private var showPro = false
    @State private var showTutorial = false
    @Namespace private var ballNamespace
    @Environment(\.dismiss) private var dismiss

    private let levelManager = LevelManager.shared
    private let store = StoreManager.shared

    var body: some View {
        ZStack {
            Color.pourBackground.ignoresSafeArea()

            VStack(spacing: 16) {
                topBar
                Spacer()
                gameBoard
                Spacer()
                bottomControls
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            let config = levelManager.configForLevel(levelNumber)
            engine.loadLevel(config)
            if levelNumber == 1 && !UserDefaults.standard.bool(forKey: "ps_tutorial_done") {
                showTutorial = true
            }
        }
        .onChange(of: engine.isComplete) { _, complete in
            if complete {
                withAnimation(.spring(response: 0.5)) { showWin = true }
            }
        }
        .onChange(of: engine.isStuck) { _, stuck in
            if stuck { showStuck = true }
        }
        .overlay {
            if showWin { winOverlay }
        }
        .alert("No Moves Left", isPresented: $showStuck) {
            Button("Undo Last Move") {
                withAnimation { engine.undo() }
            }
            Button("Restart Level") {
                withAnimation { engine.restart() }
            }
            Button("Add Extra Tube") {
                withAnimation { engine.addExtraTube() }
            }
        } message: {
            Text("You're stuck! Try undoing, restarting, or adding an extra tube.")
        }
        .sheet(isPresented: $showPro) {
            ProUpgradeView()
        }
        .overlay {
            if showTutorial {
                ZStack {
                    Color.black.opacity(0.6).ignoresSafeArea()
                    VStack(spacing: 20) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.pourPrimary)

                        Text("How to Play")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)

                        VStack(alignment: .leading, spacing: 12) {
                            tutorialStep("1", "Tap a tube to pick up the top ball")
                            tutorialStep("2", "Tap another tube to place it")
                            tutorialStep("3", "Same color balls only — or empty tube")
                            tutorialStep("4", "Fill each tube with one color to win!")
                        }

                        Button {
                            showTutorial = false
                            UserDefaults.standard.set(true, forKey: "ps_tutorial_done")
                        } label: {
                            Text("Got It!")
                                .font(.headline)
                                .frame(width: 160, height: 48)
                                .foregroundStyle(.white)
                                .background(Color.pourPrimary, in: RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(32)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
                }
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color.pourTextSecondary)
            }

            Spacer()

            VStack(spacing: 2) {
                Text("Level \(levelNumber)")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(Color.pourTextPrimary)
                Text(levelManager.worldName(for: levelNumber))
                    .font(.caption)
                    .foregroundStyle(Color.pourTextSecondary)
            }

            Spacer()

            Text("\(engine.moveCount) moves")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(Color.pourTextSecondary)
        }
    }

    // MARK: - Game Board

    private var gameBoard: some View {
        let tubeCount = engine.tubes.count
        let columns = tubeCount <= 6 ? tubeCount : (tubeCount + 1) / 2

        return LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: min(columns, 7)),
            spacing: 12
        ) {
            ForEach(Array(engine.tubes.enumerated()), id: \.element.id) { index, tube in
                TubeView(
                    tube: tube,
                    isSelected: engine.selectedTubeIndex == index,
                    isComplete: tube.isComplete,
                    namespace: ballNamespace
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        engine.tapTube(at: index)
                    }
                }
            }
        }
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        HStack(spacing: 20) {
            // Undo with counter
            Button {
                if engine.undoRemaining > 0 {
                    withAnimation(.spring(response: 0.3)) { engine.undo() }
                } else if !store.isPro {
                    showPro = true
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.title3)
                    HStack(spacing: 2) {
                        Text("Undo")
                            .font(.caption2)
                        if !store.isPro {
                            Text("(\(engine.undoRemaining))")
                                .font(.caption2)
                        }
                    }
                }
                .foregroundStyle(
                    engine.undoStack.isEmpty || engine.undoRemaining == 0
                        ? Color.pourTextSecondary.opacity(0.3)
                        : Color.pourPrimary
                )
            }
            .disabled(engine.undoStack.isEmpty && engine.undoRemaining > 0)

            // Restart
            Button {
                withAnimation(.spring(response: 0.4)) { engine.restart() }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title3)
                    Text("Restart")
                        .font(.caption2)
                }
                .foregroundStyle(Color.pourPrimary)
            }

            // Extra tube
            Button {
                if store.isPro {
                    withAnimation(.spring(response: 0.3)) { engine.addExtraTube() }
                } else {
                    showPro = true
                }
            } label: {
                VStack(spacing: 4) {
                    ZStack {
                        Image(systemName: "plus.circle")
                            .font(.title3)
                        if !store.isPro {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 8))
                                .foregroundStyle(Color.pourPrimary)
                                .offset(x: 10, y: -10)
                        }
                    }
                    Text("Tube")
                        .font(.caption2)
                }
                .foregroundStyle(Color.pourPrimary)
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Win Overlay

    private func tutorialStep(_ num: String, _ text: String) -> some View {
        HStack(spacing: 12) {
            Text(num)
                .font(.caption.weight(.bold))
                .frame(width: 24, height: 24)
                .background(Color.pourPrimary, in: Circle())
                .foregroundStyle(.white)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(Color.pourTextSecondary)
        }
    }

    private var winOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.green)

                Text("Level Complete!")
                    .font(.title.weight(.bold))
                    .foregroundStyle(.white)

                Text("\(engine.moveCount) moves")
                    .font(.title3.monospacedDigit())
                    .foregroundStyle(Color.pourTextSecondary)

                Button {
                    showWin = false
                    levelManager.completeLevel(levelNumber)
                    let nextConfig = levelManager.configForLevel(levelNumber + 1)
                    engine.loadLevel(nextConfig)
                } label: {
                    Text("Next Level")
                        .font(.headline)
                        .frame(width: 180, height: 50)
                        .foregroundStyle(.white)
                        .background(Color.pourPrimary, in: RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(32)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        }
    }
}
