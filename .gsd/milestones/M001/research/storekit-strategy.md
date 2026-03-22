# StoreKit 2 Monetization Strategy Research — PourSort

**Date:** 2026-03-22  
**Scope:** IAP model selection, paywall timing, StoreKit 2 implementation, competitive analysis  
**Recommendation:** Free-to-start with one-time Pro unlock (non-consumable, $4.99)

---

## Summary

PourSort is a casual color-sorting puzzle game. The research covers three IAP models (one-time unlock, subscription, consumable hint packs), how premium puzzle games structure monetization on iOS, and StoreKit 2 implementation specifics including restore purchases, Family Sharing, and offer codes. The recommendation is a **free-to-start model with a single non-consumable "Pro" unlock** — the Monument Valley 3 approach adapted for a sort-puzzle game.

---

## 1. Market Context: Puzzle Game Monetization in 2025–2026

### Sort Puzzle Genre Is Booming
- Puzzle game IAP revenue grew from $7.7B to $8.8B (+14.7% YoY) through 2025, with App Store puzzle revenue up 18.5% ([AppMagic via GameDevReports](https://gamedevreports.substack.com/p/appmagic-mobile-games-monetization)).
- **Sort Puzzle** subgenre specifically grew +149% YoY, and Block Puzzle exploded +911% YoY — PourSort sits in a hot category.
- Puzzle games recorded 9.7 billion downloads in 2024 with 14% YoY IAP revenue increase ([Adjust](https://www.adjust.com/blog/puzzle-games-trends-strategies/)).

### How Top Puzzle Games Monetize
| Game | Model | Price Point | Notes |
|------|-------|-------------|-------|
| Monument Valley 1 | Paid upfront | $3.99 | DLC expansions as separate IAP |
| Monument Valley 3 | Free-to-start + unlock | Single IAP | 2 free chapters, one purchase unlocks all + expansion |
| Threes! | Paid upfront | $5.99 | No IAP, no ads |
| The Room series | Paid upfront | $0.99–$4.99 | Complete experience |
| Candy Crush Saga | F2P + consumables + ads | $0.99–$99.99 | Lives, boosters, moves |
| Royal Match | F2P + consumables + ads | Various | $104.5M revenue in Aug 2025 alone |
| Water Sort Puzzle | F2P + ads + IAP | Various | Ad-heavy with optional purchases |
| Sudoku (premium) | Freemium | $4.99 removes ads | Free version fully playable |

### Two Distinct Camps
1. **Premium/artisan puzzle games** (Monument Valley, Threes!, The Room): One-time purchase, no ads, complete experience. These target players who value quality and are willing to pay upfront. They build brand reputation and receive Apple editorial features.
2. **F2P casual puzzle games** (Candy Crush, Royal Match, Water Sort): Ad-heavy with consumable IAP (lives, boosters, extra moves). Massive download volume, aggressive monetization. Hybridcasual sort puzzles increasingly use "fail offers" triggered after losing a level, which can drive 20%+ of IAP revenue.

**PourSort should target Camp 1** — a quality indie puzzle experience without aggressive ads or manipulative mechanics.

---

## 2. IAP Model Comparison for PourSort

### Option A: One-Time Pro Unlock (Non-Consumable) ✅ RECOMMENDED

**Structure:** Free download, first N levels free, single $4.99 purchase unlocks everything.

| Pros | Cons |
|------|------|
| Simplest StoreKit implementation | One-shot revenue per user |
| Supports Family Sharing natively | No recurring revenue stream |
| Supports Restore Purchases trivially | Must acquire new users for growth |
| No server-side infrastructure needed | Lower total LTV vs subscription |
| Apple editorial tends to favor this model | — |
| Aligns with Monument Valley 3 approach | — |
| No ongoing content obligation | — |
| Users feel they "own" the game | — |

**Price Point:** $4.99. The $3.99–$5.99 range is the sweet spot for premium puzzle games. Monument Valley is $3.99, Threes! is $5.99. $4.99 hits the middle. The most common price for top paid games on the App Store is $4.99.

### Option B: Auto-Renewable Subscription

**Structure:** Free download with limited content, $1.99/month or $9.99/year for full access.

| Pros | Cons |
|------|------|
| Recurring revenue | Requires continuous content updates |
| Higher LTV per user over time | Higher churn risk — users cancel |
| Apple promotes subscription apps | Overkill for a finite puzzle game |
| — | Subscription fatigue among users |
| — | More complex StoreKit implementation |
| — | Users resent subscriptions for games with fixed content |
| — | Need server or complex entitlement logic |

Subscriptions work for games with live services and regular content updates. PourSort has a fixed level set — charging monthly for a static game will generate negative reviews and refund requests. Subscriptions are gaining traction "particularly in premium mobile experiences and battle pass models" but require exclusive, ongoing content to justify recurring charges.

### Option C: Consumable Hint Packs

**Structure:** Free download with ads, sell hint packs ($0.99 for 5 hints, $2.99 for 20 hints).

| Pros | Cons |
|------|------|
| Repeatable purchases | Can feel manipulative ("pay to win") |
| Revenue from engaged players | Requires careful difficulty balancing |
| Low barrier to first purchase | Doesn't support Family Sharing |
| — | Consumables can't be restored |
| — | Needs ad infrastructure as primary revenue |
| — | Requires aggressive difficulty curve to drive purchases |

Consumable hint packs are the standard F2P puzzle model. But they incentivize frustrating game design — you make puzzles harder to sell hints. This conflicts with the premium quality PourSort should target. In sort puzzle games specifically, fail offers drive ~20% of IAP revenue, which means difficulty is deliberately tuned to frustrate.

### Hybrid Option: Pro Unlock + Optional Hint Pack

Worth considering as a middle ground: one-time Pro unlock ($4.99) as the primary monetization, plus a small consumable hint pack ($0.99 for 10 hints) for players who want help. Pro users get a few free hints included. This keeps the premium feel while offering a secondary revenue stream.

---

## 3. Paywall Timing: When to Show the Upgrade Prompt

### The Monument Valley 3 Model (Recommended)
Monument Valley 3 lets players "play the first two chapters for free, then unlock the full game — including The Garden of Life expansion — with a single in-app purchase." This is the ideal model for PourSort.

### Recommended Approach for PourSort

**Free tier:** First 15–20 levels (covering tutorial + easy + first taste of medium difficulty).

**Why this number:**
- Enough to hook the player and demonstrate the core mechanic
- Player should hit a "wow, this is satisfying" moment at least 3–5 times
- Long enough to show variety in puzzle types
- Short enough that they want more
- Rating prompt should appear after completing level 8–10 (a satisfying win moment)

**Paywall trigger:** After completing the last free level, show a tasteful upgrade screen:
- "You've completed the free puzzles! Unlock all X levels with PourSort Pro."
- Show the price clearly ($4.99)
- Include a "Restore Purchases" button
- No countdown timers, no fake discounts, no manipulative dark patterns

**Soft upgrade nudge:** In the level select screen, locked levels show a subtle lock icon. Tapping them shows the upgrade prompt. Never interrupt gameplay.

### Anti-Patterns to Avoid
- Don't show paywall mid-level or during gameplay
- Don't use energy/lives system that forces waiting
- Don't create artificial difficulty spikes at the paywall boundary
- Don't show upgrade popups on every app launch
- Don't use "limited time offer" fake urgency

---

## 4. StoreKit 2 Implementation Guide

### Product Configuration

```
Product ID: com.poursort.pro
Type: Non-Consumable
Price: $4.99 (Tier 5)
Family Sharing: Enabled
```

Optional secondary product:
```
Product ID: com.poursort.hints10
Type: Consumable
Price: $0.99 (Tier 1)
Family Sharing: N/A (consumables don't support it)
```

### Key StoreKit 2 APIs

**Product fetching:** Use `Product.products(for:)` with async/await. StoreKit 2 is available from iOS 15+, uses Swift concurrency for cleaner code.

**Purchase flow:** StoreKit 2 views — `ProductView`, `StoreView` — provide built-in merchandising UI with as little as one line of code. Customize to match PourSort's visual style.

**Transaction verification:** StoreKit 2 transactions are cryptographically signed in JWS format. Automatic verification — no server needed for a pure on-device implementation.

**Entitlement check:** Use `Transaction.currentEntitlements` to check if user has purchased Pro. This is the source of truth for unlocked content.

### Purchase UI Context (iOS 18.2+)
Starting with iOS 18.2, StoreKit requires UI context for purchases. In SwiftUI, read the `purchase` environment value to get a `PurchaseAction` instance — the system handles context automatically.

### Offer Codes (WWDC 2025 Enhancement)
Offer codes are now available for **non-consumables** (not just subscriptions), back-deployed to iOS 16.3. This is significant for PourSort's cross-promotion strategy:
- Generate offer codes in App Store Connect
- Users can redeem via `offerCodeRedemption` API or one-time redemption URLs
- Use for: cross-promotion with other indie games, social media campaigns, press/review copies, customer support recovery

### Testing
- Use StoreKit Configuration File in Xcode for local testing (no App Store Connect needed)
- Xcode's Debug > StoreKit > Manage Transactions for inspecting purchases
- Sandbox testing for pre-release validation
- StoreKit Testing framework for automated tests

---

## 5. Restore Purchases

### Requirements
- App Store Review Guidelines (section 3.1.1) **require** a restore mechanism for any restorable in-app purchases.
- Apps have been rejected for missing restore functionality.

### Implementation with StoreKit 2

**Proactive restore (automatic):** StoreKit 2 automatically makes up-to-date transactions available to your app via `Transaction.currentEntitlements`. On first launch or reinstall, iterate through entitlements to restore access without user action.

**Manual restore (button):** Still required as a safety net. Use `AppStore.sync()` to force-sync with the App Store. Place a "Restore Purchases" button in:
1. The paywall/upgrade screen
2. Settings screen

**Code pattern:**
```swift
// Proactive: check on launch
func checkEntitlements() async {
    for await result in Transaction.currentEntitlements {
        if case .verified(let transaction) = result {
            if transaction.productID == "com.poursort.pro" {
                unlockPro()
            }
        }
    }
}

// Manual: user taps "Restore Purchases"
func restorePurchases() async throws {
    try await AppStore.sync()
    await checkEntitlements()
}
```

### Edge Cases
- Show "No previous purchases found" if restore finds nothing
- Handle network errors gracefully
- Log restore attempts for debugging

---

## 6. Family Sharing

### What It Enables
Family Sharing allows up to 6 family members to share a non-consumable purchase. One person buys PourSort Pro → entire family gets access. This is a significant value proposition for a family-friendly puzzle game.

### Configuration
- Enable in App Store Connect: In-App Purchases → select product → Family Sharing → Turn On
- Enable in StoreKit Configuration file for local testing
- Check `product.isFamilyShareable` to verify configuration

### Implementation Notes
- Non-consumable purchases support Family Sharing natively
- Consumables do NOT support Family Sharing
- The `appTransactionID` field (iOS 15+) provides unique identifiers even for Family Sharing members, enabling precise tracking
- Family Sharing status is automatically reflected in `Transaction.currentEntitlements`
- No additional code needed beyond standard entitlement checking

### Marketing Angle
- Highlight Family Sharing on the App Store listing
- "Buy once, share with your whole family" — strong value message for a $4.99 game

---

## 7. Offer Codes for Cross-Promotion

### New in 2025: Non-Consumable Offer Codes
Previously, offer codes were subscription-only. As of WWDC 2025, offer codes now work for consumables, non-consumables, and non-renewing subscriptions (back-deployed to iOS 16.3).

### Use Cases for PourSort
1. **Cross-promotion:** Partner with other indie puzzle games — exchange offer codes with each other's audiences
2. **Social media campaigns:** Giveaway codes on Twitter/Instagram to drive awareness
3. **Press & review copies:** Send codes to game reviewers instead of promo codes (which are limited to 100/app/version)
4. **Customer support:** Compensate users who experienced issues
5. **Launch promotion:** Limited-time free unlock codes to drive initial downloads and reviews

### Implementation
- Generate codes in App Store Connect (up to 25,000 per quarter for subscriptions; limits for non-consumables TBD but similar mechanism)
- Implement in-app redemption via `offerCodeRedemption` SwiftUI modifier or `presentOfferCodeRedeemSheet` for UIKit
- Each code has a one-time redemption URL for deep linking from email/web campaigns
- Successful redemption creates a standard `Transaction` — handle like any other purchase

### Best Practices
- Provide redemption flow inside the app alongside customized messaging
- Use within existing marketing channels (email, social, in-app support)
- Each code has an associated redemption URL with the code prepopulated for seamless deep linking

---

## 8. Recommendation: PourSort Monetization Strategy

### Primary: Free-to-Start + One-Time Pro Unlock

```
Model:           Free-to-start, non-consumable unlock
Product:         "PourSort Pro" — com.poursort.pro  
Price:           $4.99
Free content:    First 15-20 levels
Paid content:    All remaining levels + future level packs
Family Sharing:  Enabled
Restore:         Proactive + manual button
Ads:             None (clean, premium experience)
```

### Rationale

1. **Genre fit:** Premium puzzle games (Monument Valley, Threes!, The Room) prove this model works. Monument Valley 3 specifically adopted free-to-start + single unlock and it's the closest comparable.

2. **Sort puzzle differentiation:** The sort puzzle market is dominated by ad-heavy F2P games (Water Sort Puzzle, etc.) with aggressive monetization. A clean, ad-free premium experience at $4.99 stands out — it's the "Monument Valley of sorting puzzles."

3. **Implementation simplicity:** Non-consumable purchase is the simplest StoreKit 2 implementation. No server needed, automatic transaction verification, straightforward entitlement checking, native Family Sharing support.

4. **Apple editorial favorability:** Apple consistently features premium games that respect users. No-ads, one-time-purchase games with beautiful design get App Store features — which is worth far more than incremental ad revenue.

5. **Sustainable without obligation:** Unlike subscriptions, no pressure to ship new content on a schedule. Ship level packs when ready as free updates to existing Pro users (drives positive reviews and word-of-mouth).

6. **Family-friendly:** Family Sharing makes $4.99 effectively $0.83/person for a family of 6 — excellent value proposition.

### Future Expansion Options (Post-Launch)
- **Level packs as separate non-consumables** ($1.99 each) if demand warrants
- **Cosmetic themes** (non-consumable) for tube/liquid visual styles
- Add small consumable hint pack only if user data shows demand
- Apple Arcade listing as parallel distribution channel

---

## 9. Sources

1. [WWDC 2025: What's New in StoreKit](https://dev.to/arshtechpro/wwdc-2025-whats-new-in-storekit-and-in-app-purchase-31if) — Offer codes for non-consumables, JWS enhancements
2. [Mastering StoreKit 2 in SwiftUI (2025)](https://medium.com/@dhruvinbhalodiya752/mastering-storekit-2-in-swiftui-a-complete-guide-to-in-app-purchases-2025-ef9241fced46) — Complete implementation guide
3. [Apple StoreKit 2 Developer Page](https://developer.apple.com/storekit/) — SwiftUI views, security, built-in localization
4. [RevenueCat: iOS IAP Tutorial with StoreKit 2](https://www.revenuecat.com/blog/engineering/ios-in-app-subscription-tutorial-with-storekit-2-and-swift/) — Restore purchases, App Review requirements
5. [Non-Consumable IAP with StoreKit 2](https://www.createwithswift.com/implementing-non-consumable-in-app-purchases-with-storekit-2/) — Step-by-step Xcode 26 tutorial
6. [Consumable IAP with StoreKit 2](https://www.createwithswift.com/implementing-consumable-in-app-purchases-with-storekit-2/) — Consumable purchase flow
7. [AppMagic: Mobile Games Monetization 2025](https://gamedevreports.substack.com/p/appmagic-mobile-games-monetization) — Sort Puzzle +149% YoY, Puzzle $8.8B total
8. [Adjust: Puzzle Games Trends](https://www.adjust.com/blog/puzzle-games-trends-strategies/) — 9.7B downloads, 14% IAP growth
9. [Monument Valley 3 App Store](https://apps.apple.com/us/app/monument-valley-3/id6443563379) — Free-to-start + single unlock model
10. [Apple Developer Forums: StoreKit 2 Restore](https://developer.apple.com/forums/thread/714954) — AppStore.sync() for restore
11. [Adapty: IAP Tutorial](https://adapty.io/blog/in-app-purchase-tutorial-for-ios/) — Family Sharing for non-consumables
12. [Apple: Supporting Family Sharing](https://developer.apple.com/documentation/storekit/supporting-family-sharing-in-your-app) — Family Sharing documentation
13. [WWDC 2025: What's New in StoreKit (Video)](https://developer.apple.com/videos/play/wwdc2025/241/) — Offer codes expansion, UI context
14. [Gamigion: Hybridcasual Puzzles Monetization](https://www.gamigion.com/hybridcasual-puzzles-turning-failure-into-revenue/) — Sort puzzle fail offers, revenue distribution
15. [Applixir: Game Monetization Guide 2025](https://www.applixir.com/blog/the-ultimate-game-monetization-strategy-guide-in-2025-and-beyond/) — Genre-specific recommendations
