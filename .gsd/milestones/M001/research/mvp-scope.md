# MVP Scope: v1.0 vs v1.1+ Feature Prioritization

> **Research Date:** March 22, 2026
> **Based On:** Competitor analysis (20 games), pain-point research, monetization data, App Store review requirements, retention benchmarks, and player sentiment analysis
> **Goal:** Define minimum features for App Store approval + positive first-week ratings, vs what's safe for updates

---

## Executive Summary

PourSort v1.0 needs to nail three things: **core gameplay that feels polished**, **enough content to not feel empty**, and **the "no-ads" premium trust signal**. Everything else is a retention lever that can ship in v1.1+.

The biggest risk isn't missing features — it's shipping a half-polished v1.0 that gets 3-star reviews saying "good idea, needs work." In this genre, first impressions are permanent. Competitors with 4.5+ ratings built that base in their first month and never lost it. Games that launched rough never recovered.

App Store Review has rejected minimal puzzle games for "insufficient functionality" (Guideline 4.2). A bare-bones sort game with just tap-to-move and 50 levels risks rejection. The bar is: guided tutorial, meaningful level count, at least one assist mechanic (undo), and visual polish that signals "finished product."

---

## The v1.0 / v1.1+ Decision Framework

Each feature is evaluated on four criteria:

| Criterion | Weight | Why |
|-----------|--------|-----|
| **App Store approval risk** | Critical | Rejection = weeks of delay, Apple flags your app |
| **First-week rating impact** | High | Early reviews determine organic discovery permanently |
| **Retention (Day 1 / Day 7)** | High | Top 25% puzzle games retain 31% Day 1, 9% Day 7 |
| **Development effort** | Medium | Solo dev — every week of scope delays launch |

---

## v1.0 — MUST SHIP

These features are non-negotiable for App Store approval and a 4.5+ launch rating.

### 1. Core Gameplay Loop
- **Tap tube to move top ball(s)**
- **Ball placement rules** (same color or empty tube only)
- **Win detection** (each tube single color)
- **One-finger control** — 100% of competitors use this; anything else would feel wrong

**Why v1.0:** This IS the game. Without this, there's nothing.

### 2. Guided Tutorial (First 3–5 Levels)
- Interactive, not text-wall
- Show tap mechanics, undo button, what "solved" looks like
- First level must be trivially easy (3 colors, 2 empty tubes)

**Why v1.0:** App Store Review rejected a minimal puzzle game specifically because the first level wasn't guided enough. Reviewers "need to be guided, not just left to figure things out." Additionally, ~90% of puzzle games across all markets have tutorials. Day 1 retention for puzzle games is 20–31% — onboarding is the biggest lever.

### 3. Level Content: 500+ Levels at Launch
- Algorithmic generation, seed-based, deterministic
- Every level verified solvable by solver
- Progressive difficulty curve with "wave" pattern (not monotonic increase)

**Why v1.0:** Competitors advertise "thousands of levels." A game that stops at 200 gets angry reviews — one App Store listing shows users complaining: "This game completely stops at level 200. This game lied about the amount of levels." 500 is the minimum credible floor. 1000+ is the target.

**What to cut to hit this:** Use 4 difficulty tiers (Easy/Medium/Hard/Expert) mapped to color count (3–4 / 5–6 / 7–8 / 9+). Tube capacity stays at 4 for v1.0. Variable capacity (3 or 5) is v1.1.

### 4. Undo Move
- Unlimited undo, free of charge
- Multi-step undo (not just last move)
- Clear visual feedback on undo action

**Why v1.0:** 90% of competitors have undo. The #1 differentiator of the highest-rated sort game (Ball Sort by Longwind Studio, "best ball sort game") is **free unlimited undo**. Users explicitly cite free undo as the reason they prefer it. In ad-supported games, undo is gated behind ads — PourSort's free unlimited undo IS the competitive advantage. Gating it in any way in v1.0 undermines the premium positioning.

### 5. Restart Level
- Always free, always available
- Returns to exact initial state (same seed, same layout — NOT a reshuffled puzzle)

**Why v1.0:** 100% of competitors have this. Users specifically complain when restart gives a different puzzle: "Colors change on restart, making it impossible to retry a strategy."

### 6. Add Extra Empty Tube
- Available as a limited helper (earn through gameplay or IAP)
- NOT ad-gated (ever)

**Why v1.0:** 80% of competitors have this. It's the safety valve for stuck players. Without it, players at hard levels have ONLY "restart" — which feels like failure. Extra tube lets them recover without losing all progress. This prevents the "impossible without tools" complaint that's in ~40% of competitor negative reviews.

### 7. Smooth Pour/Ball Animation
- Satisfying arc/physics on ball movement
- Color-matched particle/sparkle on tube completion
- Level-complete celebration (confetti, scale bounce, etc.)

**Why v1.0:** "Satisfaction" is the core emotional hook of this genre. Users describe these games as "meditation" and "stress relief." The animation quality IS the product differentiation. A ball that teleports between tubes is a 3-star game. A ball that flows with a satisfying arc and sound is a 5-star game. Every competitor that gets 4.5+ has polished animations.

### 8. Haptic Feedback
- Light tap on ball pickup
- Medium impact on ball placement
- Success pattern on tube completion
- Celebration pattern on level complete

**Why v1.0:** This is PourSort's key differentiator vs web-wrapper competitors. Native SwiftUI + Core Haptics is a genuine advantage. Only ~10% of competitors focus on haptic/audio experience. Haptics are cheap to implement and disproportionately impact perceived quality. Bedtime players (major use case) often play with sound off — haptics become the primary sensory feedback.

### 9. Sound Design
- Pour/placement sounds (satisfying, soft)
- Tube completion chime
- Level complete fanfare
- Background ambient (optional, toggle-able)
- Mute toggle easily accessible

**Why v1.0:** Only 10% of competitors emphasize audio, but the ones that do (Water Sort: Match Color) explicitly market "therapeutic water sounds" and "relaxing melodies." Sound is table stakes for a premium-feel game. Without it, the app feels like a web prototype. The sound-off use case (bedtime) is covered by haptics.

### 10. Level Progress Persistence
- SwiftData storage of completed levels, current level, stars
- Survive app kill and phone restart
- No cloud sync needed for v1.0 (see v1.1)

**Why v1.0:** Losing progress is cited in ~30% of competitor crash-related complaints. Players at level 500+ who lose progress leave 1-star reviews and never come back. This is a trust-destroying bug, not a feature gap.

### 11. No Ads — Ever
- Zero ad SDKs in the binary
- No ad framework imports
- Privacy nutrition label: clean

**Why v1.0:** This is the entire market positioning. The #1 complaint across every competitor (mentioned in ~80% of negative reviews) is ads. Users are willing to pay $2.99–$4.99 to escape ads but feel cheated by fake "remove ads" purchases. PourSort's zero-ad positioning drives reviews, trust, and organic growth. Including even one ad framework pollutes the privacy label and undercuts the brand promise.

### 12. IAP: Pro Unlock ($3.99)
- One-time purchase, not subscription
- Unlocks: unlimited hints, all themes, exclusive game modes (future)
- StoreKit 2 implementation
- Restore purchases working correctly
- Introductory price: $3.99 → raise to $4.99 post-500 reviews

**Why v1.0:** Revenue. Without monetization, there's no sustainable product. One-time purchase is the only model that matches user expectations in this genre — users "explicitly reject subscriptions" for simple puzzle games. The free tier must be generous enough to hook players (all levels playable, limited undo → actually unlimited undo, basic theme). Pro is for power users and supporters.

**Note on scope:** For v1.0, Pro unlock can simply grant unlimited hints + a few bonus themes. The "exclusive game modes" mentioned in the IAP description ship in v1.1 (timed challenge, minimal moves). This is fine — the IAP value proposition grows over time, and early adopters get everything added for free.

### 13. Settings Screen
- Sound on/off
- Haptics on/off
- Color accessibility mode (symbols/patterns on balls)
- Restore purchases
- Rate app link
- Privacy policy link

**Why v1.0:** Apple requires privacy policy link and restore purchases for IAP apps. The rest is basic quality-of-life that prevents 1-star reviews from users who can't mute sound or need accessibility.

### 14. Color Accessibility Mode
- Symbols or patterns overlaid on colored balls (★ ● ■ ▲ ♦ ♥ etc.)
- Not just a palette swap — geometric shapes that work regardless of color vision

**Why v1.0:** Only 10% of competitors have any color blind mode, and those modes are criticized as inadequate (palette swap only). Users "explicitly request symbols/letters/numbers overlaid on colors." 8% of men have color vision deficiency. This is a genuine differentiator that costs relatively little to implement (symbol overlay on ball view) and directly drives 5-star reviews from an underserved audience. It's also an Apple editorial signal — Apple loves accessibility features.

### 15. Basic Stats
- Current level / total levels
- Levels completed count
- Current streak (days played)

**Why v1.0:** Users request "stats to provide goals at higher levels." A minimal stats display gives a sense of progress and accomplishment. Full stats dashboard is v1.1. The streak counter is a lightweight retention mechanic that costs almost nothing to build.

---

## v1.0 — NICE TO HAVE (Ship if time allows, cut if needed)

### 16. Hint System (Basic)
- Show the next optimal move (highlight source and destination tube)
- Limited: 3 free hints per level, unlimited with Pro
- Earnable: 1 bonus hint per 5 levels completed

**Assessment:** Hints are in ~60% of competitors and users explicitly request them. However, a well-designed undo + extra tube covers most "stuck" scenarios. If hints slip to v1.0.1 (a fast follow), it's survivable. A broken or unhelpful hint system is worse than no hints at all — so only ship if the solver-backed hint engine is solid.

### 17. Daily Challenge
- One puzzle per day, same for all players (date-based seed)
- Streak tracking (consecutive days completed)
- Simple share: "I solved today's PourSort in X moves"

**Assessment:** Daily challenges are a proven Day 7+ retention mechanic. Wordle proved the model. However, they require careful design (what difficulty? what happens if you fail? is it really the same for everyone?). If the daily challenge system needs more than 2 days to build, defer to v1.0.1. The core level progression is sufficient for first-week retention.

---

## v1.1 — SAFE TO DEFER (First major update, 2–4 weeks post-launch)

### 18. Themes & Customization
- Multiple tube styles (glass, wood, neon, seasonal)
- Multiple ball designs (classic, bubbles, gems)
- Background themes (dark, light, nature, abstract)
- Some free, premium themes behind Pro unlock

**Why v1.1:** Themes are in ~30% of competitors and drive engagement but not acquisition. No user will give a 1-star review because there's only one theme. However, themes ARE the cosmetic monetization path — they justify the Pro price and give returning players something new. Ship 2–3 themes in v1.0 (default + dark mode + one premium), expand to 10+ in v1.1.

### 19. iCloud Sync
- Cross-device progress sync
- Silent, automatic, no user action required

**Why v1.1:** "No cloud sync" appears in competitor complaints, but it's primarily from power users with multiple devices. First-week reviewers are playing on one phone. iCloud sync is technically non-trivial (conflict resolution, migration) and risky to ship untested. Defer and get it right.

### 20. Full Statistics Dashboard
- Move counts per level
- Time per level
- First-try solve rate
- Personal bests
- Performance trends (graph)
- Average moves by difficulty tier

**Why v1.1:** The basic stats in v1.0 (level count, streak) cover the "sense of progress" need. A full dashboard is a delightful surprise in the first update — it gives existing players a reason to return and review. Power users will love it, but it won't make or break first-week ratings.

### 21. Timed Challenge Mode
- Optional time pressure (3-star system: fast/medium/slow solve)
- Never forced — always opt-in
- Leaderboard-ready (prep for Game Center)

**Why v1.1:** Users are divided on timers. Many say "I play this to relax, I hate the timer." Making it a separate opt-in mode threads the needle, but it requires its own UI, scoring system, and balance testing. Not worth the risk for v1.0.

### 22. Minimal Moves Mode
- Challenge: solve in fewest moves possible
- Star rating based on optimal vs actual moves
- Requires solver to compute optimal solution

**Why v1.1:** Great engagement mechanic for advanced players, but requires the solver to not just verify solvability but compute optimal path length. Additional development and testing effort. v1.1.

---

## v1.2+ — FUTURE ROADMAP

### 23. Achievements / Badges
- "Perfectionist" (10 levels first-try), "Streak Master" (30 day streak), etc.
- In-app achievement wall
- Optional Game Center integration

**Why v1.2:** Achievements require the stats infrastructure from v1.1 to track qualifying events. Building achievements without solid stat tracking leads to buggy, unreliable unlocks — which is worse than no achievements. Let stats stabilize in v1.1, then add achievements in v1.2.

### 24. Game Center Integration
- Leaderboards (moves, time, streak)
- Achievements sync
- Turn-based or asynchronous multiplayer (v2.0+)

**Why v1.2:** Game Center is increasingly underused — most casual puzzle players don't care about it. The competitive players who do care need the timed/minimal-moves modes from v1.1 first. Game Center also adds review complexity (entitlements, capability) for marginal v1.0 benefit.

### 25. Seasonal Events
- Holiday-themed levels (Christmas, Halloween, Spring)
- Limited-time challenges
- Seasonal cosmetics

**Why v1.2+:** Events are the strongest long-term retention mechanic — 91% of top puzzle games use recurring live events. But they require content pipeline, scheduling infrastructure, and push notification setup. This is LiveOps. Premature for a v1.0 solo dev. Build the foundation in v1.0–v1.1, then add events as the game matures.

### 26. Multiplayer / Social
- Race mode (solve same puzzle faster)
- Share replays
- Friend leaderboards

**Why v2.0:** Requires server infrastructure, matchmaking, or at minimum GameKit. Way out of scope for MVP. But the social-driven engagement that Adjust highlights as critical for retention long-term makes this a strategic investment when the player base justifies it.

### 27. Mystery / Hidden Mode
- Some balls have hidden colors (revealed on placement)
- Adds an information-theory layer to the puzzle

**Why v1.2+:** Only 15% of competitors have this, and the one that does it well (Ball Sort - Color Game's "?" mode) uses it as a genuine differentiator. Worth building, but it's essentially a new game mode that needs its own difficulty curve and solver verification. Post-launch.

### 28. Variable Tube Capacity
- Some levels with 3-ball tubes (quick), some with 5-ball tubes (deep)
- Mixed-capacity levels in late game

**Why v1.1–v1.2:** Adds variety that prevents the "same puzzle over and over" complaint. But it requires UI adjustments (different tube heights), generator updates, and solver updates. Good v1.1 content expansion that keeps existing players engaged.

### 29. Level Skip
- Skip a level you're stuck on, come back later
- Limited skips available (earn more through play)

**Why v1.1:** Users request this. With generous undo + extra tube, fewer players get truly stuck in v1.0. But for the difficulty spikes in levels 300+, skip becomes important. Simple to implement once the level map UI exists.

---

## Feature-to-Version Matrix

| Feature | v1.0 | v1.0.1 | v1.1 | v1.2+ |
|---------|:----:|:------:|:----:|:-----:|
| Core gameplay (tap, move, win) | ✅ | | | |
| Tutorial (guided first 5 levels) | ✅ | | | |
| 500+ levels (algo-generated) | ✅ | | | |
| Unlimited undo | ✅ | | | |
| Restart level | ✅ | | | |
| Extra empty tube | ✅ | | | |
| Pour animation + celebration | ✅ | | | |
| Haptic feedback | ✅ | | | |
| Sound design | ✅ | | | |
| Level progress persistence | ✅ | | | |
| Zero ads | ✅ | | | |
| IAP Pro unlock ($3.99) | ✅ | | | |
| Settings screen | ✅ | | | |
| Color accessibility (symbols) | ✅ | | | |
| Basic stats (level, streak) | ✅ | | | |
| Hint system | ✅* | ✅ | | |
| Daily challenge | ✅* | ✅ | | |
| Themes (3 basic) | ✅ | | | |
| Themes (10+ expanded) | | | ✅ | |
| iCloud sync | | | ✅ | |
| Full stats dashboard | | | ✅ | |
| Timed challenge mode | | | ✅ | |
| Minimal moves mode | | | ✅ | |
| Variable tube capacity | | | ✅ | |
| Level skip | | | ✅ | |
| Achievements / badges | | | | ✅ |
| Game Center | | | | ✅ |
| Seasonal events | | | | ✅ |
| Mystery / hidden mode | | | | ✅ |
| Multiplayer / social | | | | ✅ (v2.0) |

*Ship in v1.0 if time allows; otherwise fast-follow in v1.0.1

---

## Risk Assessment

### Biggest v1.0 Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| App Store rejection for "minimal functionality" | Medium | High (weeks delay) | Ship tutorial, 500+ levels, settings, accessibility, IAP — well above the bar |
| First-week reviews say "needs more content" | Low | High | 500+ levels + daily challenge. No competitor with 500+ levels gets "not enough content" reviews |
| Animation doesn't feel satisfying | Medium | Critical | Prototype animation early, get TestFlight feedback. This is the #1 perceived quality signal |
| Difficulty curve too steep or too flat | Medium | High | Use waved difficulty model from research. TestFlight beta with 50+ testers to calibrate |
| Solver/generator produces unsolvable levels | Low | Critical | Every level must pass solver verification before being playable. No exceptions |

### What Competitors Shipped at Launch (Reverse-Engineered)

Based on earliest App Store reviews and version histories:

| Game | Launch Features | Rating |
|------|----------------|--------|
| Water Sort Puzzle (2020) | Core gameplay, undo (ad-gated), restart, extra tube (ad-gated), 200+ levels | 4.7★ |
| Ball Sort Puzzle (2020) | Core gameplay, undo, restart, extra tube, progressive difficulty | 4.7★ |
| Woody Sort (2023) | Core gameplay, undo, restart, 3-star system, basic customization, coin system | 4.5★ |
| Ball sort! magic (2025) | Core gameplay, hidden elements, covered bottles, star collection, chapter chests | 4.5★ |

The 4.5+ launch games all had: core loop + undo + restart + enough levels + one distinctive quality (polish, customization, or innovation). None launched with achievements, Game Center, seasonal events, or multiplayer.

---

## Recommendation: The v1.0 Cut Line

**Ship in v1.0 (non-negotiable):**
1. Core gameplay with polished animations and haptics
2. 500+ solver-verified levels with progressive difficulty
3. Guided tutorial (first 5 levels)
4. Unlimited undo + restart + extra tube
5. Sound design + mute toggle
6. Color accessibility mode (symbols on balls)
7. Pro unlock IAP ($3.99) + restore purchases
8. Level progress persistence (SwiftData)
9. Basic stats (level count, streak)
10. Settings screen with all required links
11. 2–3 visual themes (default, dark, one premium)

**Ship in v1.0 if time allows, otherwise v1.0.1:**
- Hint system
- Daily challenge with streak

**Explicitly defer (safe for v1.1+):**
- Everything else. Expanded themes, iCloud sync, stats dashboard, timed mode, achievements, Game Center, events, multiplayer.

The goal is a tight, polished v1.0 that earns 4.5+ stars in its first week — then build on that foundation with regular updates that give players reasons to come back and review again.

---

## Sources

1. Competitor Analysis — `.gsd/milestones/M001/research/competitor-analysis.md` (20 games analyzed)
2. Pain Points Research — `.gsd/milestones/M001/research/pain-points.md` (user review sentiment)
3. Monetization Research — `.gsd/milestones/M001/research/monetization.md` (pricing, conversion data)
4. Launch Strategy — `.gsd/milestones/M001/research/launch-strategy.md` (UA channels, TestFlight)
5. Game Psychology — `.gsd/milestones/M001/research/game-psychology.md` (reward schedules, flow state)
6. Difficulty Design — `.gsd/milestones/M001/research/difficulty-design.md` (parameter scaling)
7. Udonis Puzzle Games Report — blog.udonis.co (retention: top 25% = 31% Day 1, 9% Day 7)
8. Adjust Puzzle Games Report — adjust.com (Day 1 retention 20–24%, feature utilization: 91% top games use events)
9. Igor Kulman, "Beating App Store Review" (2026) — blog.kulman.sk (rejection for minimal functionality, tutorial requirements)
10. Color Ball Sort Puzzle 2025 App Store listing — "completely stops at level 200" user complaint
11. Ball Sort Puzzle - Color Game listing — developer confirmed "Remove Ads doesn't remove bonus videos"
12. Balls Puzzle user reviews — "impossible to solve without buying an extra tube" at level 505
13. FoxData Top Puzzle Games 2025 — foxdata.com (genre rankings, retention patterns)
14. Zco Mobile Game Development Guide 2026 — zco.com (MVP phasing strategy)
15. StudioKrew Mobile Game Trends 2025 — studiokrew.com (hybrid-casual 30% of revenue growth)
