# Level Generation for Color/Ball Sort Puzzle Games

## Summary

Ball sort puzzle (also known as color sort, water sort) level generation requires careful algorithmic design because the general solvability problem is NP-complete. The most reliable approach for a mobile game is **reverse-solving** (start from a solved state, apply random legal moves in reverse to shuffle) combined with a **BFS/DFS solver to validate and score** generated puzzles. Difficulty is controlled by tuning the number of colors, tube capacity, extra empty tubes, and shuffle depth, then filtering with a solver to measure minimum moves required.

## Game Model

### Formal Definition

- **n** colors (each appearing exactly **p** times)
- **n** filled tubes + **k** empty tubes (typically k=2)
- Each tube has capacity **p** (usually 4)
- Total balls: n × p
- **Goal state:** each tube contains p balls of a single color (or is empty)
- **Legal moves:** move the top ball from one tube to another tube if:
  - The destination tube is not full
  - The destination tube is empty OR the top ball matches the moved ball's color

### Computational Complexity

The ball sort puzzle is **NP-complete** in the general case (Ito et al., FUN 2022). Key findings from the academic literature:

- An instance is sortable by ball-moves **if and only if** it is sortable by water-moves (the two puzzle variants are equivalent from a solvability standpoint)
- Every solvable instance has a solution of **polynomial length**, placing the problem in NP
- For the special case of tube height h=2 with k≥2 empty tubes, **all instances are solvable** and a shortest solution can be found in O(n) time
- For h=3 with k=2, and h=4 with k=3, there exist **unsolvable instances** — meaning random generation can produce impossible puzzles
- Optimal solvers using A*/BFS with hash-based state deduplication can solve puzzles with up to 14 colors in under a second

**Implication for level generation:** You cannot just randomly shuffle balls and guarantee solvability. You need either a construction-by-design approach or generate-then-verify.

### Sources
- Ito, T. et al. "Sorting Balls and Water: Equivalence and Computational Complexity." FUN 2022 / Theoretical Computer Science (2023). https://arxiv.org/pdf/2202.09495
- Ruangwises, S. "Physical Zero-Knowledge Proof for Ball Sort Puzzle." 2023. https://arxiv.org/html/2302.07251v4

---

## Generation Approaches

### Approach 1: Reverse-Solving (Recommended)

Start from a solved state and apply random moves **in reverse** to create the initial puzzle state. Since every reverse step is a legal forward step, the resulting puzzle is **guaranteed solvable**.

This is the standard technique used across puzzle game generation (Sokoban, Rush Hour, etc.) and is well-documented in the procedural generation literature.

**Advantages:**
- 100% solvability guarantee by construction
- Control over minimum solution length (= number of reverse moves)
- Fast — no solver needed during generation (only for difficulty scoring)

**Disadvantages:**
- Naive reverse shuffling may produce trivially easy puzzles (moves that obviously undo themselves)
- Distribution of generated puzzles is biased toward "nearby" states
- Needs heuristics to avoid shallow/boring shuffles

### Approach 2: Generate-and-Test

Randomly distribute balls across tubes, then run a solver to check solvability. Reject unsolvable or trivially easy puzzles.

**Advantages:**
- Can produce a wider variety of puzzle states
- Solver also provides minimum move count (difficulty metric)

**Disadvantages:**
- Many generated puzzles will be unsolvable (waste of computation)
- Solver cost per puzzle can be high for large n
- Random puzzles tend to cluster around either very easy or unsolvable

### Approach 3: Hybrid (Recommended for Production)

Use reverse-solving as the primary generator, then run a BFS solver to:
1. Verify solvability (safety net)
2. Compute minimum moves to solution (difficulty scoring)
3. Reject puzzles below a difficulty threshold

This is the approach used by most successful puzzle games.

---

## Reverse-Solving Algorithm

### Core Idea

```
SOLVED STATE → apply N random reverse moves → PUZZLE STATE
```

A "reverse move" in ball sort is simply a legal forward move applied to the solved state. Since ball sort moves are fully reversible (you can always move a ball back), any state reachable from the solved state by legal moves is guaranteed to be solvable back to the solved state.

### Pseudocode: Basic Reverse Shuffle

```
function generatePuzzle(numColors, tubeCapacity, numEmptyTubes, shuffleMoves):
    // Step 1: Create solved state
    tubes = []
    for color in 0..<numColors:
        tube = [color] * tubeCapacity   // e.g., [red, red, red, red]
        tubes.append(tube)
    for _ in 0..<numEmptyTubes:
        tubes.append([])                 // empty tubes

    // Step 2: Apply random legal moves to shuffle
    moveCount = 0
    visitedStates = Set()
    visitedStates.add(canonicalize(tubes))

    while moveCount < shuffleMoves:
        // Find all legal moves
        possibleMoves = []
        for src in 0..<tubes.count:
            if tubes[src].isEmpty: continue
            topBall = tubes[src].last
            for dst in 0..<tubes.count:
                if src == dst: continue
                if tubes[dst].count >= tubeCapacity: continue
                if tubes[dst].isEmpty OR tubes[dst].last == topBall:
                    possibleMoves.append((src, dst))

        if possibleMoves.isEmpty: break

        // Pick a random move (with filtering, see below)
        (src, dst) = randomChoice(possibleMoves)

        // Apply move
        ball = tubes[src].removeLast()
        tubes[dst].append(ball)

        // Check if this state is new (avoid cycles)
        state = canonicalize(tubes)
        if state in visitedStates:
            // Undo and try again
            tubes[dst].removeLast()
            tubes[src].append(ball)
            continue

        visitedStates.add(state)
        moveCount += 1

    return tubes
```

### Pseudocode: Canonicalization (for cycle detection)

```
function canonicalize(tubes):
    // Sort tubes to make state order-independent
    // (tube [A,B,C] at position 0 == tube [A,B,C] at position 3)
    tubeStrings = []
    for tube in tubes:
        tubeStrings.append(tube.toString())
    tubeStrings.sort()
    return tubeStrings.joined(separator: ";")
```

### Shuffle Quality Heuristics

Naive random shuffling produces weak puzzles. Apply these heuristics:

1. **Avoid immediately reversible moves:** Don't move a ball from tube A to tube B if the last move was B→A.

2. **Prefer moves that increase entropy:** Favor moves that break up monochrome groups. A tube with [red, red, red, blue] is more "shuffled" than [red, red, red, red].

3. **Prefer moves to non-empty tubes:** Moving to an empty tube is less disruptive than mixing colors in a partially-filled tube.

4. **Track color dispersion:** Measure how many tubes each color appears in. Higher dispersion = more shuffled. Stop only when minimum dispersion threshold is met.

5. **Minimum unique-color-per-tube threshold:** Ensure most tubes contain at least 2 different colors before accepting the puzzle.

### Pseudocode: Improved Shuffle with Entropy

```
function generatePuzzleImproved(numColors, tubeCapacity, numEmpty, shuffleMoves):
    tubes = createSolvedState(numColors, tubeCapacity, numEmpty)

    lastMove = nil
    moveCount = 0
    visited = Set()
    visited.add(canonicalize(tubes))

    while moveCount < shuffleMoves:
        moves = getAllLegalMoves(tubes, tubeCapacity)

        // Filter out reverse of last move
        if lastMove != nil:
            moves = moves.filter { $0 != (lastMove.dst, lastMove.src) }

        // Score each move by how much it increases disorder
        scoredMoves = []
        for (src, dst) in moves:
            score = computeEntropyGain(tubes, src, dst)
            scoredMoves.append((src, dst, score))

        // Weighted random selection favoring high-entropy moves
        (src, dst) = weightedRandomChoice(scoredMoves)

        // Apply and check for cycles
        applyMove(tubes, src, dst)
        state = canonicalize(tubes)
        if state in visited:
            undoMove(tubes, src, dst)
            continue
        visited.add(state)

        lastMove = (src, dst)
        moveCount += 1

    // Post-check: verify minimum disorder
    if colorDispersion(tubes) < threshold:
        return generatePuzzleImproved(...)  // retry

    return tubes

function computeEntropyGain(tubes, src, dst):
    ball = tubes[src].last
    srcColors = uniqueColors(tubes[src])
    dstColors = uniqueColors(tubes[dst])

    score = 0
    // Moving to a tube with different colors = mixing = good
    if !tubes[dst].isEmpty AND tubes[dst].last == ball:
        score += 0  // same color stacking, neutral
    if ball NOT IN dstColors:
        score += 2   // introducing new color to tube
    if srcColors.count == 1:
        score -= 1   // breaking a solved tube, moderate value
    if tubes[dst].isEmpty:
        score -= 1   // using empty tube, less mixing
    return max(0, score)
```

---

## Solver for Validation & Difficulty Scoring

After generating a puzzle, run a solver to compute the **minimum number of moves** to the solution. This serves as both a solvability check and the primary difficulty metric.

### BFS Solver (Optimal Solution)

```
function solve(tubes, tubeCapacity) -> (solvable: Bool, minMoves: Int):
    startState = canonicalize(tubes)
    if isSolved(tubes): return (true, 0)

    queue = Queue()
    queue.enqueue((tubes, 0))
    visited = Set()
    visited.add(startState)

    while !queue.isEmpty:
        (currentTubes, depth) = queue.dequeue()

        for (src, dst) in getAllLegalMoves(currentTubes, tubeCapacity):
            newTubes = applyMove(copy(currentTubes), src, dst)
            state = canonicalize(newTubes)

            if state in visited: continue
            visited.add(state)

            if isSolved(newTubes):
                return (true, depth + 1)

            queue.enqueue((newTubes, depth + 1))

    return (false, -1)

function isSolved(tubes) -> Bool:
    for tube in tubes:
        if tube.isEmpty: continue
        if tube.count != tubeCapacity: return false
        if !allSameColor(tube): return false
    return true
```

### Solver Optimizations

1. **Canonical state representation:** Sort tubes before hashing to treat permutations of tube order as identical states. This dramatically reduces the state space.

2. **Move pruning:**
   - Don't move from a solved tube (all same color, full)
   - Don't move to an empty tube if another empty tube exists (symmetric)
   - Don't move a ball to a tube where it doesn't match the top (except empty)
   - Don't reverse the immediately previous move

3. **Hash-based visited set:** Use a 32-bit or 64-bit hash of the canonical state rather than storing full states. Collision risk is acceptable for puzzle generation (false negatives just mean slightly suboptimal difficulty scoring).

4. **Depth-limited search:** For difficulty scoring, cap BFS depth at some maximum (e.g., 50 moves). If no solution is found within the limit, the puzzle is either too hard or unsolvable — either way, reject it.

5. **Iterative deepening DFS:** Alternative to BFS that uses less memory. Better for "is it solvable?" checks where you don't need the optimal solution length.

---

## Difficulty Parameters

### Primary Parameters

| Parameter | Symbol | Effect on Difficulty | Typical Range |
|-----------|--------|---------------------|---------------|
| Number of colors | n | More colors = harder | 2–14 |
| Tube capacity | p | More balls per tube = harder | 3–5 (usually 4) |
| Extra empty tubes | k | More empty = easier | 1–3 (usually 2) |
| Shuffle depth | S | More shuffles = harder | 10–200 |

### Difficulty Metrics (computed by solver)

| Metric | Description | Correlation with Difficulty |
|--------|-------------|---------------------------|
| **Minimum moves** | BFS-optimal solution length | Primary difficulty indicator |
| **Color dispersion** | Avg number of tubes each color appears in | Higher = harder |
| **Max depth before first completion** | How many moves before any tube is fully sorted | Higher = harder |
| **Dead-end density** | Number of states in BFS tree that are dead ends | Higher = more confusing |
| **Branching factor** | Avg number of legal moves per state | Higher = more choices = harder to find right path |

### Difficulty Tiers (Recommended Starting Points)

```
Level  1–10:   n=3,  p=4, k=2, shuffleMoves=15,  targetMinMoves=5–10
Level 11–30:   n=4,  p=4, k=2, shuffleMoves=25,  targetMinMoves=10–15
Level 31–60:   n=5,  p=4, k=2, shuffleMoves=40,  targetMinMoves=15–25
Level 61–100:  n=7,  p=4, k=2, shuffleMoves=60,  targetMinMoves=20–35
Level 101–150: n=9,  p=4, k=2, shuffleMoves=80,  targetMinMoves=30–45
Level 151–200: n=11, p=4, k=2, shuffleMoves=100, targetMinMoves=35–55
Level 201+:    n=12, p=4, k=2, shuffleMoves=120, targetMinMoves=40–60
```

**Note:** These are starting points. Actual difficulty perception varies — playtest and adjust.

### Reducing Empty Tubes for Harder Puzzles

Dropping from k=2 to k=1 empty tube is the single biggest difficulty spike. With only 1 empty tube, many configurations become unsolvable, and the solver must verify carefully. This should be reserved for "expert" difficulty or special challenge levels.

**Warning:** With k=1, a significant percentage of randomly shuffled states may be unsolvable. The generation loop will need more retries.

---

## Difficulty Curve Design

### The Flow Channel

The ideal difficulty curve follows Csikszentmihalyi's flow channel: difficulty rises in proportion to player skill acquisition. For a puzzle game:

```
Difficulty
    │        ╱ ─ ─ Frustration zone
    │      ╱
    │    ╱ ← Flow channel (target)
    │  ╱
    │╱─ ─ ─ Boredom zone
    └──────────────────── Level number
```

### Practical Curve Design

1. **Introduce one parameter at a time:**
   - Levels 1–5: 2 colors, 2 empty tubes (tutorial)
   - Levels 6–10: 3 colors, 2 empty tubes
   - Levels 11–20: 4 colors, 2 empty tubes
   - Gradually increase from there

2. **Sawtooth pattern within tiers:** Within each color-count tier, difficulty should oscillate — a hard puzzle followed by an easier one gives the player relief and a sense of progress.

3. **Difficulty scoring formula:**

```
function difficultyScore(puzzle):
    solvable, minMoves = solve(puzzle)
    if !solvable: return -1

    score = 0
    score += minMoves * 3                           // primary factor
    score += numColors * 5                           // more colors = harder
    score += (2 - numEmptyTubes) * 20                // fewer empties = much harder
    score += colorDispersion(puzzle) * 2             // spread-out colors = harder
    score -= numMonochromeTubes(puzzle) * 4          // already-solved tubes = easier
    return score
```

4. **Level selection pipeline:**

```
function generateLevelForDifficulty(targetScore, tolerance):
    params = getParamsForScoreRange(targetScore)  // look up n, k, shuffleDepth

    for attempt in 0..<MAX_ATTEMPTS:
        puzzle = generatePuzzleImproved(params)
        score = difficultyScore(puzzle)

        if score >= targetScore - tolerance AND score <= targetScore + tolerance:
            return puzzle

    // If no puzzle found in range, relax tolerance and retry
    return generateLevelForDifficulty(targetScore, tolerance * 1.5)
```

---

## Complete Level Generator Pipeline

### Pseudocode: Full Pipeline

```
function generateLevel(levelNumber) -> Puzzle:
    // Step 1: Determine target difficulty from level number
    config = difficultyConfig(levelNumber)
    // config = { numColors, tubeCapacity, numEmpty, shuffleMoves,
    //            targetMinMoves, minDispersion }

    for attempt in 0..<100:
        // Step 2: Generate via reverse shuffle
        tubes = generatePuzzleImproved(
            config.numColors,
            config.tubeCapacity,
            config.numEmpty,
            config.shuffleMoves
        )

        // Step 3: Validate with solver
        (solvable, minMoves) = solve(tubes, config.tubeCapacity)

        if !solvable: continue  // shouldn't happen with reverse-solve, but safety net

        // Step 4: Check difficulty is in target range
        if minMoves < config.targetMinMoves.lowerBound: continue  // too easy
        if minMoves > config.targetMinMoves.upperBound: continue  // too hard

        // Step 5: Check quality metrics
        if colorDispersion(tubes) < config.minDispersion: continue

        // Step 6: Check no tube is already solved (unless low level)
        if levelNumber > 10 AND hasMonochromeTube(tubes): continue

        // Step 7: Success
        return Puzzle(
            tubes: tubes,
            numColors: config.numColors,
            tubeCapacity: config.tubeCapacity,
            minMoves: minMoves,
            levelNumber: levelNumber
        )

    // Fallback: relax constraints
    return generateLevel(levelNumber) with relaxed constraints

function difficultyConfig(levelNumber) -> Config:
    // Progressive difficulty table
    switch levelNumber:
        case 1...5:   return Config(n=2, p=4, k=2, shuffle=15,  target=3...8)
        case 6...10:  return Config(n=3, p=4, k=2, shuffle=20,  target=5...12)
        case 11...20: return Config(n=4, p=4, k=2, shuffle=30,  target=8...18)
        case 21...40: return Config(n=5, p=4, k=2, shuffle=45,  target=12...25)
        case 41...70: return Config(n=7, p=4, k=2, shuffle=60,  target=18...35)
        case 71...100: return Config(n=9, p=4, k=2, shuffle=80, target=25...45)
        case 101...150: return Config(n=11, p=4, k=2, shuffle=100, target=30...55)
        case 151+:    return Config(n=12, p=4, k=2, shuffle=120, target=35...60)
```

---

## Implementation Notes for iOS/Swift

### Performance Considerations

- **BFS solver memory:** For n=12, p=4, the state space is enormous. Use hash-based visited set (not full state storage). A 64-bit hash in a `Set<UInt64>` is sufficient.
- **Generation should be async:** Run on a background queue. Pre-generate the next 5–10 levels while the player is solving the current one.
- **Cache generated levels:** Store generated levels (as tube configurations) so they're deterministic across sessions. Use the level number as seed for the PRNG.
- **Solver timeout:** Cap solver at 2 seconds or 500K states explored. If it times out, reject the puzzle and regenerate.

### State Representation

```swift
// Compact representation for fast hashing
struct PuzzleState: Hashable {
    let tubes: [[UInt8]]  // UInt8 color IDs (0 = empty slot)

    var canonical: [UInt8] {
        // Sort tubes lexicographically for order-independent comparison
        tubes.sorted().flatMap { $0 }
    }
}
```

### Seeded Generation for Reproducibility

```swift
// Same levelNumber always produces the same puzzle
func generateLevel(_ levelNumber: Int) -> Puzzle {
    var rng = SeededRandomNumberGenerator(seed: UInt64(levelNumber) &* 2654435761)
    // Use &rng in all random calls during generation
    ...
}
```

---

## Key Takeaways

1. **Never use pure random generation** — it produces unsolvable puzzles. Always use reverse-solving or verify with a solver.
2. **Reverse-solve + solver validation** is the gold standard approach. Fast, reliable, controllable.
3. **Minimum moves to solution** (from BFS) is the best single difficulty metric.
4. **2 empty tubes** is the sweet spot for most difficulty levels. 1 empty tube is expert-only.
5. **Tube capacity of 4** is the industry standard — it balances depth of play with visual clarity.
6. **Pre-generate levels** on a background thread. BFS solver can take 100ms–2s for hard puzzles.
7. **Sawtooth difficulty curve** within gradually increasing tiers keeps players in the flow channel.
8. **Canonicalize states** (sort tubes) for both cycle detection during generation and state deduplication during solving.

---

## References

1. Ito, T. et al. "Sorting Balls and Water: Equivalence and Computational Complexity." 11th International Conference on Fun with Algorithms (FUN 2022). https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.FUN.2022.16
2. Ruangwises, S. "Physical Zero-Knowledge Proof for Ball Sort Puzzle." 2023. https://arxiv.org/html/2302.07251v4
3. GeeksforGeeks. "Designing algorithm to solve Ball Sort Puzzle." https://www.geeksforgeeks.org/dsa/designing-algorithm-to-solve-ball-sort-puzzle/
4. Robinson, C. "Solving a game called 'ball sort puzzle'." 2023. https://calebrob.com/algorithms/2023/08/13/ball-sort-puzzle.html
5. Kociemba, H. "WaterBallSortPuzzleOptimalSolver." https://github.com/hkociemba/WaterBallSortPuzzleOptimalSolver
6. tjwood100. "ball-sort-puzzle-solver" (includes random puzzle generator). https://github.com/tjwood100/ball-sort-puzzle-solver
7. Faubert, A. "ball-sort-puzzle-solver" (Golang, confirmed level 578 is unsolvable without extra tube). https://github.com/AnthonyFaubert/ball-sort-puzzle-solver
8. "Automatic Level Generation for Puzzle Games" (reverse simulation method). https://abagames.github.io/joys-of-small-game-development-en/procedural/puzzle_level.html
9. Snellman, J. "Writing a procedural puzzle generator." 2019. https://www.snellman.net/blog/archive/2019-05-14-procedural-puzzle-generator/
10. "Procedural Puzzle Generation: A Survey." IEEE Transactions on Games, 2019. https://www.researchgate.net/publication/333226463_Procedural_Puzzle_Generation_A_Survey
