import SwiftUI

@main
struct DepositboxApp: App {
    @StateObject private var store = Store()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .onChange(of: purchases.isPurchased) { _, newValue in
                    store.isPro = newValue
                }
        }
    }
}
