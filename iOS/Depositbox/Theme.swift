import SwiftUI

/// Unique visual theme for Depositbox -- built for this app's domain, not shared.
enum AppTheme {
    static let accent = Color(red: 0.180, green: 0.490, blue: 0.420)
    static let background = Color(red: 0.055, green: 0.090, blue: 0.071)
    static let card = Color.white.opacity(0.06)
    static let cardBorder = accent.opacity(0.25)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.62)

    static let titleFont = Font.system(.largeTitle, design: .serif).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content.simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil
                )
            }
        )
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}
