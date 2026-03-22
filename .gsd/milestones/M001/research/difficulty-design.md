# Difficulty Curve Design for a 1000+ Level Color Sort Puzzle Game

## Summary

This document synthesizes research on difficulty curve design for a ball/color sort puzzle game targeting 1000+ levels. It covers parameter scaling (colors, balls per tube, tubes, empty tubes, shuffle depth), what makes levels easy vs hard, chapter/world organization, mechanic introduction pacing, and lessons from successful puzzle games (Candy Crush, Wordle, 2048, and existing ball sort titles).

---

## 1. Core Difficulty Parameters

A color sort puzzle's difficulty is controlled by five primary parameters. These interact multiplicatively — changing two at once creates exponential difficulty jumps.

### 1.1 Number of Colors (n)

The single biggest difficulty lever. More colors = more interleaving = more decisions.

| Range | Perceived Difficulty | Context |
|-------|---------------------|---------|
| 3     | Tutorial / Trivial  | First 20 levels |
| 4     | Easy                | Levels 20–80 |
| 5     | Easy-Medium         | Levels 80–200 |
| 6     | Medium              | Levels 200–400 |
| 7–8   | Medium-Hard         | Levels 400–600 |
| 9–10  | Hard                | Levels 600–850 |
| 11–12 | Expert              | Levels 850–1000+ |

**Reference:** Bubble Sorting (CrazyGames) uses Easy: 3 colors, Medium: 5 colors, Hard: 7 colors. PlayBrain's Color Sort uses Easy: 4 colors + 2 empty, Medium: 6 colors + 2 empty, Hard: 8 colors + 2 empty.

### 1.2 Balls Per Tube (h) — Tube Capacity

Controls the depth of planning required. Higher capacity = more buried balls = more moves to uncover target colors.

| Capacity | Effect |
|----------|--------|
| 3        | Quick puzzles, few blocking situations. Good for tutorials and breather levels. |
| 4        | Standard. The sweet spot used by most existing ball sort games for the majority of levels. |
| 5        | Deep. Significantly more complex — balls buried 4-deep require multi-step excavation. |

**Research insight:** Academic work (Ito et al., 2022) proved that ball sort puzzles are NP-complete in the general case. The capacity parameter `h` directly affects the state space exponentially: a tube of capacity 5 with n colors has O(n^5) possible states per tube vs O(n^3) for capacity 3.

**Recommendation:** Keep capacity at 3 for levels 1–50, move to 4 for levels 50–700 (the bulk of the game), introduce capacity 5 as a "hard mode" variant from level 700+. Never change capacity and color count simultaneously.

### 1.3 Number of Tubes (total)

Total tubes = n (color tubes) + k (extra empty tubes). The total number of tubes determines the visual complexity and the physical screen layout constraints.

| Total Tubes | Screen Fit | Notes |
|-------------|-----------|-------|
| 5–7         | Single row | Clean, approachable |
| 8–10        | Two rows | Standard mid-game |
| 11–14       | Two rows, tighter spacing | Late game, need good UI |
| 14+         | Requires scroll or zoom | Avoid unless special mode |

### 1.4 Extra Empty Tubes (k)

The most direct "difficulty dial." More empties = more breathing room = easier.

| k (empty tubes) | Effect |
|-----------------|--------|
| 3+              | Very easy. Hard to get stuck. Tutorial only. |
| 2               | Standard easy. The player has comfortable workspace. |
| 1               | Standard difficulty. The core challenge of most levels. |
| 0               | Expert / Special challenge. Not all configurations are solvable with 0 empties. |

**Academic backing:** Research shows that with k = 2 empty tubes, any configuration with h = 2 is solvable. But for h ≥ 3, there exist unsolvable configurations even with k = 2. With k = 1, solvability is not guaranteed for most nontrivial configurations.

**Rule of thumb for PourSort:**
- Levels 1–100: k = 2 (safe, forgiving)
- Levels 100–500: k = 2, occasionally k = 1 for "challenge" levels
- Levels 500–800: k = 1 standard, k = 2 for breather levels
- Levels 800–1000+: k = 1 standard, some levels with k = 0 (verified solvable by solver)

### 1.5 Shuffle Depth (Scramble Quality)

How thoroughly the initial configuration is mixed. This is the "hidden" difficulty parameter most players never see but feel deeply.

| Shuffle Depth | Method | Effect |
|---------------|--------|--------|
| Light (5–15 reverse moves) | Start from solved state, make N random valid moves backwards | Creates puzzles solvable in ~N moves. Very learnable. |
| Medium (20–50 reverse moves) | More reverse moves with diversification | Player can't easily "see" the solution path. Standard difficulty. |
| Deep (100+ reverse moves or forward-generated) | Generate random valid configuration, verify solvability with solver | Maximum entropy. Requires genuine strategic thinking. |

**Best practice for procedural generation:** Generate levels by working backwards from a solved state. This guarantees solvability. The number of backwards steps directly correlates with difficulty. Add the solver verification as a second pass to ensure the minimum number of moves meets a threshold (reject too-easy puzzles).

**Minimum move thresholds by difficulty tier:**
- Tutorial: 3–8 moves
- Easy: 8–20 moves
- Medium: 20–50 moves
- Hard: 50–100 moves
- Expert: 100+ moves

---

## 2. What Makes a Level "Easy" vs "Hard"

### 2.1 Easy Level Characteristics
- Few colors (3–4)
- Multiple empty tubes (2+)
- Low tube capacity (3)
- At least one color is already partially sorted (has 2+ same-color balls adjacent at bottom)
- Multiple valid first moves
- Short solution path (< 15 moves optimal)
- The "obvious" move is usually the correct move
- Forgiving: most move sequences eventually lead to a solution

### 2.2 Hard Level Characteristics
- Many colors (8+)
- Few empty tubes (1 or 0)
- High tube capacity (4–5)
- All colors maximally interleaved (no two same-color balls adjacent initially)
- Key "crux" moves that must be found (one wrong move early leads to a dead-end)
- Long solution path (50+ moves optimal)
- "Buried" critical balls: a color needed for the current tube is at the bottom of a tube behind 3 other colors
- One-way moves (irreversible pours that commit the player)
- Required use of empty tubes as temporary storage (Tower of Hanoi-like planning)

### 2.3 The Difficulty Formula

A simple composite score for level difficulty:

```
difficulty = (n_colors * 3) + (tube_capacity * 2) + (max(0, 2 - empty_tubes) * 4) + (shuffle_depth / 10) + interleave_penalty
```

Where `interleave_penalty` is a measure of how mixed the initial state is (0 for pre-sorted, up to 10 for maximum entropy).

This formula should be calibrated against solver data (optimal move count) and player testing data (average attempts to complete).

---

## 3. Difficulty Curve Shape

### 3.1 The Sawtooth Pattern (Industry Standard)

Successful puzzle games don't use a smooth linear ramp. They use a **sawtooth** pattern: generally upward trend punctuated by periodic difficulty drops ("breather" levels).

```
Difficulty
    ^
    |     /\      /\        /\
    |    /  \    /  \      /  \       /\
    |   /    \  /    \    /    \     /  \
    |  /      \/      \  /      \   /    \
    | /                \/        \ /      \
    |/                            v
    +----------------------------------------> Level
```

**Candy Crush's approach:** The game is built around difficulty pacing with deliberate spikes. After every sequence of moderate levels, there's a "blocker" level that most players need multiple attempts to pass. This creates tension/release cycles. Episodes (chapters of ~15 levels) typically have 1–2 hard levels, with the last level in a chapter often being the hardest.

### 3.2 Recommended Cadence for PourSort

Within every chapter of ~20 levels:
- Levels 1–3: **Warm-up.** Below the current difficulty baseline. Build confidence.
- Levels 4–10: **Rising.** Gradual increase. Each level slightly harder than the last.
- Levels 11–13: **Plateau.** Maintain peak difficulty for that chapter.
- Level 14–15: **Spike.** The hardest level(s) in the chapter. The "boss" level.
- Levels 16–18: **Cool-down.** Noticeably easier. Reward the player. Satisfying completions.
- Levels 19–20: **Tease.** Medium difficulty introducing a visual/thematic hint of what's coming next.

### 3.3 Long-Arc Pacing (Macro Curve)

Over the full 1000+ levels:
- **Levels 1–50 (Onboarding):** Very gentle ramp. Introduce one concept at a time. Success rate should be near 100% first-try.
- **Levels 50–200 (Early Game):** Player feels competent. Steady upward ramp. First genuine "stuck" moments around level 80–100.
- **Levels 200–500 (Mid Game):** Core game. Most parameter variety. The difficulty plateau where the game "lives." Introduce new mechanics here.
- **Levels 500–800 (Late Game):** Harder configurations but player is skilled. Fewer new mechanics, more combinations of existing ones.
- **Levels 800–1000 (End Game):** Expert territory. Maximum parameters. Only dedicated players reach here.
- **Levels 1000+ (Endless/Post-game):** Procedurally generated. Difficulty oscillates around a hard baseline.

---

## 4. Chapter/World Organization

### 4.1 Structure

| Unit | Size | Purpose |
|------|------|---------|
| **Level** | 1 puzzle | Single play session (30s – 5min) |
| **Chapter** | 15–25 levels | One sitting (~20–45 min). Has internal difficulty arc. |
| **World** | 3–5 chapters (50–100 levels) | Visual theme. May introduce one major mechanic. |
| **Act** | 2–3 worlds (150–250 levels) | Story/progression milestone. |

### 4.2 Recommended World Map (1000 levels)

| World | Levels | Colors | Capacity | Empties | Theme | New Mechanic |
|-------|--------|--------|----------|---------|-------|-------------|
| 1: First Pour | 1–50 | 3→4 | 3 | 2–3 | Bright, simple | Core mechanics (tap, pour, undo) |
| 2: Getting Sorted | 51–120 | 4→5 | 3→4 | 2 | Garden/Nature | Capacity increases to 4 |
| 3: Color Cascade | 121–200 | 5→6 | 4 | 2 | Ocean/Water | Timer challenge mode (optional) |
| 4: Deep Mix | 201–300 | 6→7 | 4 | 2→1 | Mountains | First k=1 levels |
| 5: Tricky Tubes | 301–400 | 7 | 4 | 1–2 | Desert/Sand | Locked tubes (unlock by completing adjacent) |
| 6: Rainbow Rush | 401–500 | 7→8 | 4 | 1–2 | Rainbow/Sky | Move limit mode |
| 7: Crystal Clear | 501–600 | 8→9 | 4 | 1 | Crystal Cave | Tube capacity mixed (3 and 4 in same puzzle) |
| 8: Sort Storm | 601–700 | 9→10 | 4→5 | 1 | Storm/Lightning | Capacity 5 introduction |
| 9: Neon Nights | 701–850 | 10→11 | 4–5 | 1 | Neon City | "Dark" balls (color hidden until first move) |
| 10: Grand Pour | 851–1000 | 11→12 | 4–5 | 0–1 | Gold/Platinum | Zero-empty challenges |

### 4.3 Chapter Transitions

Each world's final chapter should end with a **"gate" level** — noticeably harder than anything before. This creates a sense of accomplishment when cleared. But never make gates unsolvable-feeling; always ensure a solver confirms a reasonable solution exists.

Between worlds, provide a **free/easy bonus level** that introduces the new world's visual theme with a trivially easy puzzle. This resets the player's stress level and creates excitement for new content.

---

## 5. Mechanic Introduction Pacing

### 5.1 Core Principle

From Candy Crush's design philosophy: "New mechanics need enough visibility for players to learn and become comfortable with them." Each new mechanic should follow a 3-stage introduction:

1. **Tutorial level:** The mechanic is isolated. Only that mechanic matters. (1 level)
2. **Practice levels:** The mechanic combined with easy base gameplay. (2–3 levels)
3. **Integration levels:** The mechanic as part of normal difficulty progression. (ongoing)

### 5.2 Mechanic Introduction Schedule

| Level Range | Mechanic | Why Here |
|-------------|----------|----------|
| 1–5 | Tap to select, tap to pour | Core gameplay |
| 6–10 | Undo button | Safety net before real challenge |
| 20–30 | Restart level | Player encounters first "stuck" state |
| 50–70 | Tube capacity change (3→4) | Natural complexity increase |
| 120–140 | Optional timer/move-count challenges | For players wanting extra challenge |
| 200–220 | First k=1 empty tube level | Major difficulty jump, well-prepared |
| 300–320 | Locked tubes | New strategic element |
| 400–420 | Move limit mode | Changes from "can you solve it" to "can you solve it efficiently" |
| 500–520 | Mixed tube capacities | Adds visual/logical complexity |
| 700–720 | Capacity 5 | Deep planning required |
| 850+ | Hidden-color balls | Information asymmetry |
| 950+ | Zero empty tubes | Peak challenge |

### 5.3 Cadence Rule

**Never introduce two new mechanics within 30 levels of each other.** Players need time to internalize each mechanic before the next one arrives. After introducing a mechanic, maintain at least 20 levels of "normal" gameplay using that mechanic before the next introduction.

**Exception:** Cosmetic/reward mechanics (new ball skins, backgrounds, etc.) can be introduced anytime. They aren't cognitive load.

---

## 6. Lessons from Successful Puzzle Games

### 6.1 Candy Crush Saga

**Key insight:** Difficulty pacing is the core monetization driver. When players hit a difficulty spike and get close to winning but fail, they're most likely to convert (buy extra moves, boosters). The game's "sawtooth" difficulty curve is deliberately designed to create these moments.

- **Chapter structure:** Episodes of ~15 levels. Each episode has 1-2 "hard" levels, at most one "super hard" or "nightmarishly hard."
- **Blocker introduction:** New blockers are introduced with tutorial levels first, then mixed with established blockers. "Any new blocker has to earn its place by offering a distinct behaviour" — Candy Crush's John Davies.
- **20,000+ levels** maintained with variety by using AI to generate draft levels and bots to simulate difficulty before player release.
- **Long-term pacing:** Over longer stretches, the game introduces "plateaus that test patience more than skill." Progress slows not because levels are impossible, but because familiar patterns stop working.

**Takeaway for PourSort:** Design difficulty spikes intentionally. Track where players use hints/undos/extra-tubes as a proxy for difficulty. The "extra tube" purchase should align with difficulty spikes.

### 6.2 Wordle

**Key insight:** Fixed daily difficulty with high variance creates shared social experience. Some days are easy (common word, no repeated letters, common letter patterns), some days are hard (uncommon word, repeated letters, unusual patterns).

- **No progressive difficulty.** Every puzzle has the same constraints (5 letters, 6 guesses). Difficulty comes from the word chosen.
- **Retention through habit.** One puzzle per day = routine. No grind.
- **Low frustration ceiling.** Maximum 6 guesses = bounded time investment.

**Takeaway for PourSort:** Consider a "Daily Pour" feature — one curated puzzle per day with shared social comparison (solve time, move count). This adds retention without requiring endless content.

### 6.3 2048

**Key insight:** Simple rules, emergent complexity. The game never "adds" mechanics — all difficulty comes from the state growing more constrained as numbers get larger.

- **Self-escalating difficulty.** The board fills up naturally. The game gets harder as you play.
- **No level design needed.** Pure emergent difficulty.
- **Score as progression.** Reaching 2048, then 4096, etc. provides natural milestones.

**Takeaway for PourSort:** Consider a "Zen Mode" or "Endless Mode" where the player gets progressively harder randomly-generated puzzles with no specific level count. Their "score" is how many in a row they can solve. The game gets harder as the streak grows (fewer empty tubes, more colors).

### 6.4 Existing Ball Sort Games

**Common complaints from player reviews (App Store / Google Play):**
- "I'm on level 574, and very bored again. A majority of the puzzles are 4 balls." — Lack of variety is the #1 complaint.
- "When does the game change? I am at level 5519." — Games with 5000+ levels often fail to add meaningful variety.
- "I found out it's impossible to solve without buying an extra tube... Now I won't be sure if it's simply a hard level or unfairly unsolvable." — Players hate feeling cheated by intentionally unsolvable levels.
- "Not too difficult but not so easy it gets boring" — The sweet spot that successful games hit.

**Takeaway for PourSort:**
1. **Vary tube capacity** much more than competitors. The #1 differentiator.
2. **Every level must be provably solvable** without purchasing extras. Extras are convenience, not necessity.
3. **Introduce visual and mechanical variety** every 50–100 levels to prevent the "same puzzle over and over" fatigue.

---

## 7. Procedural Level Generation Strategy

### 7.1 The Backwards Generation Method

The most reliable approach for ensuring solvability:

1. **Start with a solved state** (all colors sorted into their tubes).
2. **Apply N random valid "reverse moves"** (take balls from sorted tubes and distribute them).
3. **Verify the resulting configuration** with a solver (BFS/DFS) to confirm:
   - The puzzle is solvable
   - The minimum solution length meets the difficulty target
   - There's no trivial shortcut (solution < target/3 moves)
4. **Assign a difficulty score** based on solver metrics (optimal moves, branching factor, dead-end frequency).
5. **If the puzzle doesn't meet criteria, regenerate.** This is cheap computationally.

### 7.2 Solver-Based Difficulty Metrics

After generating a puzzle, run the solver and extract:
- **Optimal move count:** The minimum moves to solve.
- **Decision points:** How many moves have more than one viable option.
- **Dead-end frequency:** How many "wrong" paths exist that lead to unsolvable states.
- **Crux depth:** How many moves into the puzzle the hardest decision occurs.

These four metrics together give a robust difficulty score that correlates well with human-perceived difficulty.

### 7.3 Difficulty Calibration

Use the formula (to be refined with real player data):

```
perceived_difficulty = 0.3 * normalized_optimal_moves 
                     + 0.25 * normalized_decision_points 
                     + 0.25 * normalized_dead_end_frequency 
                     + 0.2 * normalized_crux_depth
```

Normalize each metric to [0, 1] within its parameter range (e.g., for 6-color/4-capacity/1-empty puzzles, optimal moves might range from 15 to 80).

---

## 8. Anti-Frustration Design

### 8.1 Safety Nets (Available to All Players)
- **Unlimited undo:** Per-level, unlimited. No cost. This is the most player-friendly feature.
- **Restart level:** Free, immediate.
- **Hint system:** Show the next optimal move. Limited free hints per day; purchasable.

### 8.2 Difficulty Relief (Monetizable)
- **Extra tube:** Add one empty tube to the current puzzle. Rewarded ad or purchase.
- **Skip level:** Skip one level entirely. One free per chapter; purchasable.
- **Shuffle:** Re-scramble the current level (still solvable) for a different arrangement.

### 8.3 Dynamic Difficulty Adjustment (DDA)

If a player fails the same level 3+ times:
1. Offer a hint (free).
2. After 5 fails: Offer an extra tube (rewarded ad).
3. After 8 fails: Subtly simplify the initial arrangement (fewer interleaves) without telling the player.
4. Never make a level impossible to complete without purchase.

---

## 9. Parameter Progression Summary Table

| Level Range | Colors | Capacity | Empty Tubes | Shuffle Depth | Approx Difficulty |
|-------------|--------|----------|-------------|---------------|-------------------|
| 1–20        | 3      | 3        | 3           | Light (5–10)  | Tutorial          |
| 21–50       | 3–4    | 3        | 2–3         | Light (10–15) | Very Easy         |
| 51–80       | 4–5    | 3–4      | 2           | Light-Med (15–25) | Easy          |
| 81–120      | 5      | 4        | 2           | Medium (20–35) | Easy-Medium      |
| 121–200     | 5–6    | 4        | 2           | Medium (25–40) | Medium           |
| 201–300     | 6–7    | 4        | 1–2         | Medium (30–50) | Medium           |
| 301–400     | 7      | 4        | 1–2         | Medium-Deep (35–60) | Medium-Hard |
| 401–500     | 7–8    | 4        | 1–2         | Deep (40–70) | Hard              |
| 501–600     | 8–9    | 4        | 1           | Deep (50–80) | Hard              |
| 601–700     | 9–10   | 4–5      | 1           | Deep (60–90) | Hard-Expert       |
| 701–850     | 10–11  | 4–5      | 1           | Deep (70–100) | Expert           |
| 851–1000    | 11–12  | 4–5      | 0–1         | Deep (80+)   | Expert            |
| 1000+       | 8–12   | 3–5      | 0–2         | Variable     | Mixed/Endless     |

---

## 10. Key Design Principles (Summary)

1. **Every level must be solvable without purchases.** Trust is the foundation of retention.
2. **Never change two parameters at once.** Increase colors OR reduce empties OR increase capacity — not multiple simultaneously.
3. **Use the sawtooth pattern.** Every hard level should be followed by 2–3 easier levels.
4. **Variety prevents boredom.** Mix tube capacities, introduce visual themes, add optional challenge modes. The #1 killer of ball sort games is monotony.
5. **Introduce mechanics slowly.** One new concept per 50–100 levels. Tutorial → Practice → Integration.
6. **Difficulty comes from interleaving, not from unfairness.** Hard puzzles should feel like "I need to think harder," not "this is random/impossible."
7. **Use solver data to calibrate.** Don't guess at difficulty — measure it with optimal move counts, dead-end frequency, and decision point density.
8. **Provide safety nets generously.** Unlimited undo, easy restart, free hints. Frustration = churn.
9. **Build a Daily Pour mode.** One curated puzzle per day for habit formation and social sharing.
10. **Plan for 1000+ but design for 200.** Get the first 200 levels perfect. The parameter space will carry you for the rest with procedural generation, but the early game is where retention is won or lost.

---

## Sources

1. Dave Tech — "Making difficulty curves in games" (davetech.co.uk/difficultycurves)
2. Game Design Skills — "Puzzle Game Design: Principles, Levels, Template" (gamedesignskills.com)
3. Michael DeLally — "Level Progression and Pacing in Puzzle Games" (Medium, 2020)
4. Ito et al. — "Sorting Balls and Water: Equivalence and Computational Complexity" (FUN 2022, arxiv.org/abs/2202.09495)
5. Gamedeveloper.com — "The Player's Progress: Designing Levels for Mobile Puzzle Games" (2023)
6. PocketGamer.biz — "Crafting Candy Crush's difficulty: Blockers, level design, AI and the complexity staircase" (2026)
7. Gamigion — "How to Design Difficulty in Puzzle Games" (2025)
8. PurpleSloth — "Let's talk about difficulty design in puzzle games" (itch.io devlog, 2025)
9. Reza Hassanzadeh — "The Secret to Designing Killer Levels in Puzzle Games" (Medium, 2023)
10. Roberto Aguilar — "Level Balancing: Game Difficulty data-driven adjustments in Candy Crush" (robguilar.com, 2022)
11. Candy Crush Saga Wiki — "Hard levels" and "Difficulty" (candycrush.fandom.com)
12. CrazyGames — "Bubble Sorting" difficulty tiers
13. PlayBrain — "Color Sort" difficulty tiers
14. App Store / Google Play — Ball Sort Puzzle, Water Sort Puzzle player reviews (2024–2026)
15. Alex Bräysy — Candy Crush Saga Level Design Portfolio (alexbraysy.com)
