import Foundation
import StoreKit

@Observable @MainActor
final class StoreManager {
    static let shared = StoreManager()

    static let proUnlockID = "com.theknack.poursort.pro"

    private(set) var isPro = false
    private(set) var proProduct: Product?
    private(set) var isLoading = true

    private init() {
        Task { await loadProducts() }
        Task { await checkEntitlements() }
        Task { await listenForTransactions() }
    }

    func loadProducts() async {
        do {
            let products = try await Product.products(for: [Self.proUnlockID])
            proProduct = products.first
        } catch {
            print("[PourSort] Failed to load products: \(error)")
        }
        isLoading = false
    }

    func checkEntitlements() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            if transaction.productID == Self.proUnlockID {
                isPro = true
                return
            }
        }
    }

    private func listenForTransactions() async {
        for await result in Transaction.updates {
            guard case .verified(let transaction) = result else { continue }
            await transaction.finish()
            await checkEntitlements()
        }
    }

    func purchase() async throws -> Bool {
        guard let product = proProduct else { return false }
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            guard case .verified(let transaction) = verification else { return false }
            await transaction.finish()
            isPro = true
            return true
        case .pending, .userCancelled:
            return false
        @unknown default:
            return false
        }
    }

    func restorePurchases() async {
        try? await AppStore.sync()
        await checkEntitlements()
    }
}
