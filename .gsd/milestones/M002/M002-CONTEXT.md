# M002 Context — MVP Build

## Goal
Build PourSort v1.0 — an ad-free color sorting puzzle game with 500+ algorithmically generated levels, ready for App Store submission.

## Scope
- Core ball sort gameplay (tap tube to move, same-color stacking)
- Algorithmic level generator (reverse-solve, seed-based, solvable)
- 500+ levels across 5 worlds with progressive difficulty
- Smooth pour/ball animations (spring physics, matchedGeometryEffect)
- Undo, restart, extra tube
- Daily challenge (date-based seed)
- Pro unlock IAP ($4.99 one-time)
- Color accessibility (symbol overlays for colorblind)
- Haptic feedback
- Level progress persistence (SwiftData)
- Dark-mode-first design, amber/orange accent

## NOT in Scope (v1.1+)
- Themes/skins store
- Achievements / Game Center
- Time attack mode
- Leaderboards
- Sound effects (v1.0 ships silent + haptics)
- iCloud sync

## Constraints
- iOS 17+ (SwiftData)
- SwiftUI only (no SpriteKit)
- Bundle ID: com.theknack.poursort
- Team ID: 99H9NJ6Z6J
- No third-party dependencies
- No ads, no tracking SDKs

## Key Decisions from Research
- Monetization: Pro unlock $4.99 one-time (not subscription)
- Free tier: all 500+ levels, limited undo (3/level), basic theme
- Pro: unlimited undo, all themes, daily challenge stats, extra tube unlimited
- Level gen: reverse-solve from completed state, shuffle N moves
- Colors: 3→10, tubes: 4→14, capacity: 4, empties: 2→1
- Visual: dark-mode-first, glass tubes with frosted material, 2D balls with radial gradient
- Accent color: amber/orange
