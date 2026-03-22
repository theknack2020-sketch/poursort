import SwiftUI

struct DailyChallengeView: View {
    @State private var engine = GameEngine()
    @State private var showWin = false
    @Namespace private var ballNamespace
    @Environment(\.dismiss) private var dismiss

    private let daily = DailyChallengeManager.shared

    var body: some View {
        ZStack {
            Color.pourBackground.ignoresSafeArea()

            if daily.isCompletedToday {
                completedView
            } else {
                VStack(spacing: 16) {
                    // Top bar
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Color.pourTextSecondary)
                        }
                        Spacer()
                        VStack(spacing: 2) {
                            Text("Daily Challenge")
                                .font(.headline)
                                .foregroundStyle(Color.pourPrimary)
                            Text(daily.todayKey)
                                .font(.caption)
                                .foregroundStyle(Color.pourTextSecondary)
                        }
                        Spacer()
                        Text("\(engine.moveCount)")
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(Color.pourTextSecondary)
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Game board
                    let tubeCount = engine.tubes.count
                    let columns = tubeCount <= 6 ? tubeCount : (tubeCount + 1) / 2
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: min(columns, 7)),
                        spacing: 12
                    ) {
                        ForEach(Array(engine.tubes.enumerated()), id: \.element.id) { index, tube in
                            TubeView(tube: tube, isSelected: engine.selectedTubeIndex == index, namespace: ballNamespace)
                                .onTapGesture {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                        engine.tapTube(at: index)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Controls
                    HStack(spacing: 24) {
                        Button {
                            withAnimation(.spring(response: 0.3)) { engine.undo() }
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: "arrow.uturn.backward").font(.title3)
                                Text("Undo").font(.caption2)
                            }
                            .foregroundStyle(engine.undoStack.isEmpty ? Color.pourTextSecondary.opacity(0.3) : Color.pourPrimary)
                        }
                        .disabled(engine.undoStack.isEmpty)

                        Button {
                            withAnimation(.spring(response: 0.4)) { engine.restart() }
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: "arrow.counterclockwise").font(.title3)
                                Text("Restart").font(.caption2)
                            }
                            .foregroundStyle(Color.pourPrimary)
                        }
                    }
                    .padding(.bottom, 8)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if !daily.isCompletedToday {
                engine.loadLevel(daily.todayConfig)
            }
        }
        .onChange(of: engine.isComplete) { _, complete in
            if complete {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                daily.completeDaily(moves: engine.moveCount)
                withAnimation(.spring(response: 0.5)) { showWin = true }
            }
        }
        .overlay {
            if showWin {
                dailyWinOverlay
            }
        }
    }

    private var completedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)

            Text("Daily Complete!")
                .font(.title.weight(.bold))
                .foregroundStyle(Color.pourTextPrimary)

            if let moves = daily.todayMoves {
                Text("\(moves) moves")
                    .font(.title3.monospacedDigit())
                    .foregroundStyle(Color.pourTextSecondary)
            }

            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                Text("\(daily.streak) day streak")
                    .foregroundStyle(Color.pourTextSecondary)
            }
            .font(.subheadline)

            Text("Come back tomorrow!")
                .font(.subheadline)
                .foregroundStyle(Color.pourTextSecondary)

            Button("Back") { dismiss() }
                .font(.headline)
                .frame(width: 160, height: 48)
                .foregroundStyle(.white)
                .background(Color.pourPrimary, in: RoundedRectangle(cornerRadius: 14))
                .padding(.top, 12)
        }
    }

    private var dailyWinOverlay: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "star.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Color.pourPrimary)
                Text("Daily Solved!")
                    .font(.title.weight(.bold))
                    .foregroundStyle(.white)
                Text("\(engine.moveCount) moves")
                    .font(.title3.monospacedDigit())
                    .foregroundStyle(Color.pourTextSecondary)
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill").foregroundStyle(.orange)
                    Text("\(daily.streak) day streak")
                }
                .font(.subheadline)
                .foregroundStyle(Color.pourTextSecondary)

                Button("Done") {
                    showWin = false
                    dismiss()
                }
                .font(.headline)
                .frame(width: 160, height: 48)
                .foregroundStyle(.white)
                .background(Color.pourPrimary, in: RoundedRectangle(cornerRadius: 14))
            }
            .padding(32)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        }
    }
}
