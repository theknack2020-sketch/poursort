import SwiftUI

struct GameView: View {
    let levelNumber: Int
    @State private var engine = GameEngine()
    @State private var showWin = false
    @Namespace private var ballNamespace
    @Environment(\.dismiss) private var dismiss

    private let levelManager = LevelManager.shared

    var body: some View {
        ZStack {
            Color.pourBackground.ignoresSafeArea()

            VStack(spacing: 16) {
                // Top bar
                topBar

                Spacer()

                // Game board
                gameBoard

                Spacer()

                // Bottom controls
                bottomControls
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            let config = levelManager.configForLevel(levelNumber)
            engine.loadLevel(config)
        }
        .onChange(of: engine.isComplete) { _, complete in
            if complete {
                let impact = UINotificationFeedbackGenerator()
                impact.notificationOccurred(.success)
                withAnimation(.spring(response: 0.5)) {
                    showWin = true
                }
            }
        }
        .overlay {
            if showWin {
                winOverlay
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
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
                    namespace: ballNamespace
                )
                .onTapGesture {
                    let tap = UIImpactFeedbackGenerator(style: .light)
                    tap.impactOccurred()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        engine.tapTube(at: index)
                    }
                }
            }
        }
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        HStack(spacing: 24) {
            // Undo
            Button {
                withAnimation(.spring(response: 0.3)) {
                    engine.undo()
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.title3)
                    Text("Undo")
                        .font(.caption2)
                }
                .foregroundStyle(engine.undoStack.isEmpty ? Color.pourTextSecondary.opacity(0.3) : Color.pourPrimary)
            }
            .disabled(engine.undoStack.isEmpty)

            // Restart
            Button {
                withAnimation(.spring(response: 0.4)) {
                    engine.restart()
                }
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
                withAnimation(.spring(response: 0.3)) {
                    engine.addExtraTube()
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                    Text("Tube")
                        .font(.caption2)
                }
                .foregroundStyle(Color.pourPrimary)
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Win Overlay

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
