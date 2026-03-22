import SwiftUI

extension Color {
    // Amber/orange primary
    static let pourPrimary = Color(red: 0.90, green: 0.62, blue: 0.0)       // #E69F00
    static let pourSecondary = Color(red: 1.0, green: 0.71, blue: 0.10)     // #FFB51A
    static let pourAccent = Color(red: 1.0, green: 0.80, blue: 0.20)        // #FFCC33

    // Background (dark-mode-first)
    static let pourBackground = Color(red: 0.08, green: 0.08, blue: 0.10)   // near black
    static let pourSurface = Color(red: 0.14, green: 0.14, blue: 0.16)      // card bg
    static let pourTube = Color(red: 0.20, green: 0.20, blue: 0.22)         // tube fill

    // Text
    static let pourTextPrimary = Color.white
    static let pourTextSecondary = Color(white: 0.6)

    // Ball colors — Okabe-Ito inspired for colorblind safety
    static let ballRuby = Color(red: 0.80, green: 0.15, blue: 0.15)
    static let ballOrange = Color(red: 0.90, green: 0.62, blue: 0.00)
    static let ballYellow = Color(red: 0.94, green: 0.89, blue: 0.26)
    static let ballGreen = Color(red: 0.00, green: 0.62, blue: 0.45)
    static let ballCyan = Color(red: 0.34, green: 0.71, blue: 0.91)
    static let ballBlue = Color(red: 0.00, green: 0.45, blue: 0.70)
    static let ballPurple = Color(red: 0.58, green: 0.34, blue: 0.68)
    static let ballPink = Color(red: 0.80, green: 0.47, blue: 0.65)
    static let ballMint = Color(red: 0.35, green: 0.85, blue: 0.60)
    static let ballSlate = Color(red: 0.50, green: 0.50, blue: 0.55)
}
