import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var purchases: PurchaseManager

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                VStack(spacing: 24) {
                    Image(systemName: "star.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundStyle(AppTheme.accent)
                    Text("Depositbox Pro")
                        .font(AppTheme.titleFont)
                        .foregroundStyle(AppTheme.textPrimary)
                    Text("Refund/forfeit reason log and printable receipts")
                        .font(AppTheme.bodyFont)
                        .foregroundStyle(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    if let product = purchases.product {
                        Button {
                            Task { await purchases.purchase() }
                        } label: {
                            Text("Unlock for \(product.displayPrice)")
                                .font(AppTheme.headlineFont)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(AppTheme.accent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .accessibilityIdentifier("paywallPurchaseButton")
                        .padding(.horizontal)
                    } else {
                        ProgressView()
                    }
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("paywallRestoreButton")
                    Button("Not now") { dismiss() }
                        .foregroundStyle(AppTheme.textSecondary)
                        .accessibilityIdentifier("paywallDismissButton")
                }
                .padding()
            }
        }
    }
}
