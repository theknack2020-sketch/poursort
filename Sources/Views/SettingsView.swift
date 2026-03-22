import SwiftUI

struct SettingsView: View {
    @State private var soundEnabled = SoundManager.shared.isSoundEnabled
    @State private var showPro = false
    private let store = StoreManager.shared

    var body: some View {
        Form {
            Section("Game") {
                Toggle("Sound & Haptics", isOn: $soundEnabled)
                    .onChange(of: soundEnabled) { _, val in
                        SoundManager.shared.isSoundEnabled = val
                    }
            }

            Section("Premium") {
                if store.isPro {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                        Text("PourSort Pro Active")
                            .font(.subheadline.weight(.medium))
                    }
                } else {
                    Button {
                        showPro = true
                    } label: {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(Color.pourPrimary)
                            VStack(alignment: .leading) {
                                Text("Upgrade to Pro")
                                    .font(.subheadline.weight(.semibold))
                                Text("Unlimited undo, extra tubes, all themes")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }

            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0").foregroundStyle(.secondary)
                }

                Link("Privacy Policy", destination: URL(string: "https://theknack2020-sketch.github.io/poursort/privacy/")!)
                Link("Support", destination: URL(string: "https://theknack2020-sketch.github.io/poursort/support/")!)
            }
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $showPro) {
            ProUpgradeView()
        }
    }
}
