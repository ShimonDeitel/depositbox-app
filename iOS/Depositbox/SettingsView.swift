import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("depositbox_notifyEnabled") private var notifyEnabled = true
    @AppStorage("depositbox_showAmounts") private var showAmounts = true
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Enable reminders", isOn: $notifyEnabled)
                    Toggle("Show amounts on list", isOn: $showAmounts)
                }
                Section("Subscription") {
                    if purchases.isPurchased {
                        Label("Pro active", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(AppTheme.accent)
                    } else {
                        Button("Unlock Pro") { showPaywall = true }
                            .accessibilityIdentifier("settingsUnlockProButton")
                    }
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("restoreButton")
                }
                Section("Legal") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/depositbox-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/depositbox-app/terms.html")!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
}
