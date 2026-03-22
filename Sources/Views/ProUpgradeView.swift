import SwiftUI

struct ProUpgradeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var purchasing = false
    @State private var errorMessage: String?
    private let store = StoreManager.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color.pourBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 56))
                                .foregroundStyle(Color.pourPrimary)

                            Text("PourSort Pro")
                                .font(.title.weight(.bold))
                                .foregroundStyle(Color.pourTextPrimary)

                            Text("Unlock the full experience")
                                .font(.subheadline)
                                .foregroundStyle(Color.pourTextSecondary)
                        }
                        .padding(.top, 24)

                        // Features
                        VStack(alignment: .leading, spacing: 16) {
                            featureRow(icon: "arrow.uturn.backward.circle.fill", title: "Unlimited Undo", desc: "Take back as many moves as you need")
                            featureRow(icon: "plus.circle.fill", title: "Unlimited Extra Tubes", desc: "Add tubes whenever you're stuck")
                            featureRow(icon: "nosign", title: "No Ads. Ever.", desc: "PourSort never shows ads — Pro or free")
                        }
                        .padding(.horizontal, 24)

                        // Price button
                        if store.isLoading {
                            ProgressView()
                                .padding()
                        } else if let product = store.proProduct {
                            Button {
                                Task { await buyPro() }
                            } label: {
                                VStack(spacing: 4) {
                                    Text("Unlock Pro")
                                        .font(.headline)
                                    Text(product.displayPrice + " · One-time purchase")
                                        .font(.caption)
                                        .opacity(0.8)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .foregroundStyle(.white)
                                .background(Color.pourPrimary, in: RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.horizontal, 24)
                        }

                        if let error = errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }

                        Button("Restore Purchases") {
                            Task {
                                await store.restorePurchases()
                                if store.isPro { dismiss() }
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.pourTextSecondary)

                        // Legal
                        Text("One-time purchase. No subscription. No ads in free or Pro version.")
                            .font(.caption2)
                            .foregroundStyle(Color.pourTextSecondary.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(Color.pourTextSecondary)
                }
            }
            .disabled(purchasing)
            .overlay {
                if purchasing {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Processing...")
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    private func featureRow(icon: String, title: String, desc: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.pourPrimary)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.pourTextPrimary)
                Text(desc)
                    .font(.caption)
                    .foregroundStyle(Color.pourTextSecondary)
            }
        }
    }

    private func buyPro() async {
        purchasing = true
        errorMessage = nil
        do {
            let success = try await store.purchase()
            if success { dismiss() }
        } catch {
            errorMessage = "Purchase failed. Please try again."
        }
        purchasing = false
    }
}
