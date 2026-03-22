import SwiftUI

struct LevelSelectView: View {
    let onSelect: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    private let levelManager = LevelManager.shared

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.pourBackground.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        ForEach(0..<5, id: \.self) { world in
                            worldSection(world: world)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Levels")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.pourPrimary)
                }
            }
        }
    }

    private func worldSection(world: Int) -> some View {
        let worldNames = ["Tutorial", "Easy", "Medium", "Hard", "Expert"]
        let startLevel = world * 100 + 1
        let endLevel = startLevel + 99

        return VStack(alignment: .leading, spacing: 12) {
            Text("World \(world + 1): \(worldNames[world])")
                .font(.headline)
                .foregroundStyle(Color.pourTextPrimary)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(startLevel...min(endLevel, startLevel + 24), id: \.self) { level in
                    let isUnlocked = level <= levelManager.highestLevel
                    let isCurrent = level == levelManager.currentLevelNumber

                    Button {
                        if isUnlocked {
                            onSelect(level)
                        }
                    } label: {
                        Text("\(level)")
                            .font(.caption.weight(.medium).monospacedDigit())
                            .frame(width: 44, height: 44)
                            .foregroundStyle(
                                isCurrent ? .white :
                                isUnlocked ? Color.pourTextPrimary :
                                Color.pourTextSecondary.opacity(0.3)
                            )
                            .background(
                                isCurrent ? Color.pourPrimary :
                                isUnlocked ? Color.pourSurface :
                                Color.pourSurface.opacity(0.3),
                                in: RoundedRectangle(cornerRadius: 8)
                            )
                    }
                    .disabled(!isUnlocked)
                }
            }
        }
    }
}
