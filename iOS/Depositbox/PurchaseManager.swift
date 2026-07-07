import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let productID = "com.shimondeitel.depositbox.pro"

    @Published var isPurchased: Bool = false
    @Published var product: Product?

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await update in Transaction.updates {
                if case .verified(let transaction) = update {
                    await self?.handle(transaction)
                }
            }
        }
        Task { await load() }
    }

    deinit { updatesTask?.cancel() }

    func load() async {
        if let products = try? await Product.products(for: [Self.productID]), let p = products.first {
            product = p
        }
        await refreshEntitlement()
    }

    func purchase() async {
        guard let product else { return }
        guard let result = try? await product.purchase() else { return }
        switch result {
        case .success(let verification):
            if case .verified(let transaction) = verification {
                await handle(transaction)
            }
        default:
            break
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlement()
    }

    private func handle(_ transaction: Transaction) async {
        isPurchased = true
        await transaction.finish()
    }

    private func refreshEntitlement() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == Self.productID {
                isPurchased = true
                return
            }
        }
        isPurchased = false
    }
}
