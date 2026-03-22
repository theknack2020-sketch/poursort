# Technical Architecture Research: Ball Sort Puzzle in SwiftUI

## Summary

Ball Sort Puzzle is a stack-based sorting game where players move colored balls between tubes to group them by color. The game maps cleanly to an array-of-stacks data model, has well-defined move validation rules, and presents interesting UI challenges for SwiftUI around animation and interaction design. This document covers game state modeling, move logic, win detection, undo, rendering, interaction patterns, level data, and code architecture recommendations.

---

## 1. Game Rules & Formal Definition

The game consists of `n` colored groups of `h` balls each (total `n × h` balls), arranged across `n + e` tubes (typically `e = 2` empty tubes). Each tube has capacity `h`.

**Rules:**
- Only the top ball of each tube can be moved
- A ball can be placed on top of another ball **only if they share the same color**
- A ball can be placed into an empty tube
- A tube cannot exceed capacity `h`

**Goal:** Sort all balls so each non-empty tube contains `h` balls of a single color.

**Computational complexity:** The ball sort puzzle is NP-complete in general (Ito et al., 2022). However, typical mobile game levels with 2 empty tubes and 4-ball capacity are well within BFS/DFS solvability for validation purposes.

---

## 2. Game State Model

### Core Types

```swift
/// Represents a ball color. Using an enum with raw values for type safety.
enum BallColor: Int, Codable, CaseIterable, Identifiable {
    case red, blue, green, yellow, orange, purple, pink, cyan, brown, gray
    // Extend as needed per level pack
    
    var id: Int { rawValue }
}

/// A single ball with stable identity for animations.
struct Ball: Identifiable, Equatable, Codable {
    let id: UUID
    let color: BallColor
    
    init(color: BallColor) {
        self.id = UUID()
        self.color = color
    }
}

/// A tube is a stack (LIFO) of balls with a fixed capacity.
struct Tube: Identifiable, Equatable, Codable {
    let id: UUID
    var balls: [Ball]       // index 0 = bottom, last = top
    let capacity: Int
    
    var topBall: Ball? { balls.last }
    var isEmpty: Bool { balls.isEmpty }
    var isFull: Bool { balls.count >= capacity }
    
    /// True if tube contains only one color and is full.
    var isSorted: Bool {
        guard isFull else { return false }
        let firstColor = balls[0].color
        return balls.allSatisfy { $0.color == firstColor }
    }
}
```

### Why `Ball` Has Identity

Each ball needs a stable `UUID` so SwiftUI can animate individual balls moving between tubes. Without identity, SwiftUI can't distinguish "which red ball moved" and animations become cross-fades instead of spatial transitions.

### Game State

```swift
struct GameState: Equatable, Codable {
    var tubes: [Tube]
    var moveCount: Int
    
    var isSolved: Bool {
        tubes.allSatisfy { $0.isEmpty || $0.isSorted }
    }
}
```

The state is a flat array of tubes. Tube ordering is stable (tube indices serve as identifiers for user interaction). This is the single source of truth — all view rendering derives from this.

---

## 3. Move Validation Logic

```swift
struct Move: Codable, Equatable {
    let fromTubeIndex: Int
    let toTubeIndex: Int
}

extension GameState {
    /// Check if moving from source to destination is valid.
    func isValidMove(from source: Int, to destination: Int) -> Bool {
        guard source != destination else { return false }
        guard let sourceBall = tubes[source].topBall else { return false }
        
        let destTube = tubes[destination]
        
        // Destination must not be full
        guard !destTube.isFull else { return false }
        
        // Destination must be empty or top ball must match color
        if let destTop = destTube.topBall {
            return destTop.color == sourceBall.color
        }
        
        return true // empty tube
    }
    
    /// Returns all valid destination indices for a given source tube.
    func validDestinations(for sourceIndex: Int) -> [Int] {
        (0..<tubes.count).filter { isValidMove(from: sourceIndex, to: $0) }
    }
    
    /// Apply a move, returning the new state. Caller must validate first.
    mutating func applyMove(_ move: Move) -> Ball {
        let ball = tubes[move.fromTubeIndex].balls.removeLast()
        tubes[move.toTubeIndex].balls.append(ball)
        moveCount += 1
        return ball
    }
}
```

### Move Pruning (for solver/hint system)

To avoid trivial or redundant moves:
- Don't move a ball to an empty tube if the source tube is homogeneous (already one color only)
- Don't move from tube A to B then back from B to A (last-move check)
- Use canonical state representation (sort tube contents) to detect duplicate states in BFS

---

## 4. Win Condition Detection

```swift
var isSolved: Bool {
    tubes.allSatisfy { tube in
        tube.isEmpty || tube.isSorted
    }
}
```

This is O(n × h) but called infrequently (once per move). No optimization needed.

For a richer win experience, also track:
- `moveCount` vs par (minimum moves, precomputed per level)
- Whether solved with/without undo usage (for star ratings)

---

## 5. Undo Stack Implementation

```swift
@Observable
class GameViewModel {
    private(set) var state: GameState
    private var undoStack: [GameState] = []
    private var redoStack: [GameState] = []
    
    func performMove(_ move: Move) {
        guard state.isValidMove(from: move.fromTubeIndex, to: move.toTubeIndex) else { return }
        
        undoStack.append(state)
        redoStack.removeAll()
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            _ = state.applyMove(move)
        }
        
        checkWinCondition()
    }
    
    func undo() {
        guard let previous = undoStack.popLast() else { return }
        redoStack.append(state)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            state = previous
        }
    }
    
    func redo() {
        guard let next = redoStack.popLast() else { return }
        undoStack.append(state)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            state = next
        }
    }
    
    func restart() {
        guard let initial = undoStack.first else { return }
        undoStack.removeAll()
        redoStack.removeAll()
        withAnimation { state = initial }
    }
    
    var canUndo: Bool { !undoStack.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }
}
```

### Design Notes
- Store full `GameState` snapshots in the undo stack (not diffs). States are small (~100 balls × 16 bytes = negligible).
- Clear redo stack on any new move (standard undo/redo behavior).
- `restart()` rewinds to the initial state (first entry in undo stack or the original level state stored separately).

---

## 6. Tube Rendering with SwiftUI

### Tube View

Each tube is a vertical stack with a rounded-rect "container" shape and colored circles inside.

```swift
struct TubeView: View {
    let tube: Tube
    let isSelected: Bool
    let isValidTarget: Bool
    @Namespace var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 2) {
            // Empty slots at top
            ForEach(0..<(tube.capacity - tube.balls.count), id: \.self) { _ in
                Circle()
                    .fill(.clear)
                    .frame(width: 40, height: 40)
            }
            // Balls from top to bottom (reverse for visual stacking)
            ForEach(tube.balls.reversed()) { ball in
                BallView(ball: ball)
                    .matchedGeometryEffect(id: ball.id, in: animation)
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(strokeColor, lineWidth: isSelected ? 3 : 1.5)
                .fill(.ultraThinMaterial)
        )
    }
    
    var strokeColor: Color {
        if isSelected { return .blue }
        if isValidTarget { return .green }
        return .gray.opacity(0.5)
    }
}

struct BallView: View {
    let ball: Ball
    
    var body: some View {
        Circle()
            .fill(ball.color.swiftUIColor)
            .frame(width: 40, height: 40)
            .overlay(
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.5), .clear],
                            center: .topLeading,
                            startRadius: 2,
                            endRadius: 20
                        )
                    )
            )
            .shadow(color: ball.color.swiftUIColor.opacity(0.4), radius: 3, y: 2)
    }
}
```

### Ball Animation with matchedGeometryEffect

The critical animation technique: use `matchedGeometryEffect(id: ball.id, in: namespace)` on every `BallView`. When a ball's `UUID` moves from one tube's array to another and the view re-renders inside `withAnimation`, SwiftUI automatically interpolates the ball's position between its old and new locations — producing a smooth "fly over" animation.

This requires:
1. A shared `@Namespace` across all tube views (passed from parent)
2. Each ball has a stable `Identifiable` id (`UUID`)
3. State mutation wrapped in `withAnimation`

### Layout

Use a horizontal `LazyHGrid` or `HStack` with `ScrollView` for levels with many tubes:

```swift
ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 16) {
        ForEach(Array(state.tubes.enumerated()), id: \.element.id) { index, tube in
            TubeView(
                tube: tube,
                isSelected: selectedTubeIndex == index,
                isValidTarget: validTargets.contains(index)
            )
            .onTapGesture { handleTubeTap(index) }
        }
    }
    .padding()
}
```

---

## 7. Interaction: Tap-to-Move vs Drag-and-Drop

### Recommendation: Tap-to-Move (Primary) + Visual Feedback

**Tap-to-move** is strongly recommended as the primary interaction:

1. **Tap source tube** → top ball lifts/highlights, valid destination tubes glow green
2. **Tap destination tube** → ball animates to destination
3. **Tap source again or empty area** → deselect

This is the standard interaction in all popular ball sort games. It's simpler to implement, more accessible, works well on all screen sizes, and avoids the complexity of drag gesture collision with scroll views.

```swift
@Observable
class GameViewModel {
    var selectedTubeIndex: Int? = nil
    
    func handleTubeTap(_ index: Int) {
        if let selected = selectedTubeIndex {
            if selected == index {
                // Deselect
                selectedTubeIndex = nil
            } else if state.isValidMove(from: selected, to: index) {
                // Perform move
                performMove(Move(fromTubeIndex: selected, toTubeIndex: index))
                selectedTubeIndex = nil
            } else if state.tubes[index].topBall != nil {
                // Select new source
                selectedTubeIndex = index
            } else {
                selectedTubeIndex = nil
            }
        } else {
            // Select source if it has balls
            if state.tubes[index].topBall != nil {
                selectedTubeIndex = index
            }
        }
    }
}
```

### Why Not Drag-and-Drop

- SwiftUI's `onDrag`/`onDrop` requires `NSItemProvider` serialization, which is heavyweight for in-app moves
- `DragGesture` on individual balls conflicts with `ScrollView` gestures
- Visual ball-flying animation via `matchedGeometryEffect` already provides the "movement" feel
- Ball sort games on the App Store universally use tap-to-move

### Optional: Drag Enhancement (Later)

If drag is desired later, use a custom `DragGesture` on the tube (not individual balls), track position via `@GestureState`, and use `GeometryReader` + preference keys to determine which tube the gesture ends over. This is a polish feature, not MVP.

---

## 8. Level Data Structure

### Level Definition

```swift
struct LevelDefinition: Codable, Identifiable {
    let id: Int
    let tubeCount: Int          // includes empty tubes
    let tubeCapacity: Int       // balls per tube (typically 4)
    let emptyTubes: Int         // typically 2
    let colorCount: Int         // number of distinct colors
    let initialArrangement: [[BallColor]]  // outer = tubes, inner = bottom-to-top
    let par: Int?               // minimum moves (optional, for star rating)
    let difficulty: Difficulty
    
    enum Difficulty: String, Codable {
        case easy, medium, hard, expert
    }
}
```

### Level Generation Strategy

Two approaches:

**1. Reverse Shuffle (Recommended for guaranteed solvability)**
- Start from a solved state (each tube has `h` balls of one color)
- Apply `N` random *valid reverse moves* (take top ball from a sorted tube, put it on another tube)
- The resulting shuffled state is guaranteed solvable (just reverse the moves)
- Control difficulty by varying `N` (more shuffles = harder)

**2. Random + Verify**
- Randomly distribute `n × h` balls across `n` tubes
- Run BFS/DFS solver to verify solvability
- Reject unsolvable configurations
- Slower but produces more "natural" distributions

For a mobile game, **reverse shuffle** is the pragmatic choice. It's fast, deterministic, and always produces solvable puzzles.

### Level Packs (JSON)

```json
{
  "pack": "Classic",
  "levels": [
    {
      "id": 1,
      "tubeCount": 4,
      "tubeCapacity": 4,
      "emptyTubes": 2,
      "colorCount": 2,
      "initialArrangement": [
        ["red", "blue", "red", "blue"],
        ["blue", "red", "blue", "red"],
        [],
        []
      ],
      "par": 6,
      "difficulty": "easy"
    }
  ]
}
```

Levels can be bundled in the app as JSON resources, loaded progressively, or generated at runtime with the reverse-shuffle algorithm seeded by level number for reproducibility.

### Difficulty Scaling

| Parameter       | Easy    | Medium  | Hard    | Expert  |
|-----------------|---------|---------|---------|---------|
| Colors          | 2-3     | 4-6     | 7-9     | 10-12   |
| Tube capacity   | 4       | 4       | 4       | 4-5     |
| Empty tubes     | 2       | 2       | 2       | 1-2     |
| Shuffle moves   | 20-40   | 50-100  | 100-200 | 200+    |

---

## 9. Code Architecture Recommendations

### Pattern: MVVM with @Observable (iOS 17+)

```
PourSortApp
├── App/
│   ├── PourSortApp.swift          // @main entry
│   └── AppState.swift             // Navigation, user progress
├── Models/
│   ├── BallColor.swift
│   ├── Ball.swift
│   ├── Tube.swift
│   ├── GameState.swift            // Pure value type, no side effects
│   ├── Move.swift
│   └── LevelDefinition.swift
├── ViewModels/
│   ├── GameViewModel.swift        // @Observable, owns GameState + undo stack
│   └── LevelSelectViewModel.swift
├── Views/
│   ├── Game/
│   │   ├── GameView.swift         // Main game screen
│   │   ├── TubeView.swift
│   │   ├── BallView.swift
│   │   └── GameToolbar.swift      // Undo, restart, hint buttons
│   ├── LevelSelect/
│   │   ├── LevelSelectView.swift
│   │   └── LevelPackView.swift
│   └── Common/
│       ├── CelebrationView.swift  // Win animation
│       └── Theme.swift            // Colors, sizes
├── Services/
│   ├── LevelLoader.swift          // JSON → LevelDefinition
│   ├── LevelGenerator.swift       // Reverse-shuffle algorithm
│   ├── ProgressStore.swift        // UserDefaults/SwiftData persistence
│   └── HapticManager.swift
└── Resources/
    └── Levels/
        ├── pack_classic.json
        └── pack_advanced.json
```

### Key Architectural Decisions

1. **GameState is a value type (struct).** Enables undo via snapshot, Equatable for diffing, Codable for persistence. No reference semantics surprises.

2. **GameViewModel is @Observable.** Owns the mutable state, undo/redo stacks, selection state, and animation triggers. The single coordination point.

3. **Pure functions for game logic.** `isValidMove`, `isSolved`, `applyMove` live as extensions on `GameState`. They're testable without any UI or ViewModel involvement.

4. **matchedGeometryEffect for ball animation.** A shared `@Namespace` is created at the `GameView` level and passed to all `TubeView` children. Ball identity (UUID) is the geometry effect ID.

5. **Level loading is a service, not a model concern.** `LevelLoader` reads JSON, `LevelGenerator` creates random levels. Both produce `LevelDefinition` values. The ViewModel converts these to initial `GameState`.

6. **Tap-to-move as primary interaction.** Two-tap flow: tap source, tap destination. No drag gesture complexity at MVP.

### Testing Strategy

- **Unit tests:** `GameState` logic (move validation, win detection, apply move) — pure functions, easy to test
- **Unit tests:** Undo/redo behavior on `GameViewModel`
- **Unit tests:** Level generator (output is solvable, correct ball counts)
- **Snapshot/preview tests:** `TubeView`, `BallView` in various states
- **Integration tests:** Full game flow (load level → make moves → win)

### Performance Considerations

- State is small (10-14 tubes × 4-5 balls = ~50-70 Ball structs). No performance concern for diffing or undo snapshots.
- `matchedGeometryEffect` handles animation interpolation natively — no manual `Timer` or `CADisplayLink` needed.
- Level generation via reverse-shuffle is O(N) where N = shuffle moves. Sub-millisecond.
- BFS solver for hint system: manageable for typical puzzles (14 colors with state dedup runs in <1s). Run on background thread.

---

## 10. Sources

1. GeeksforGeeks — "Designing algorithm to solve Ball Sort Puzzle" — https://www.geeksforgeeks.org/dsa/designing-algorithm-to-solve-ball-sort-puzzle/
2. Ito et al. — "Sorting Balls and Water: Equivalence and Computational Complexity" (FUN 2022) — https://arxiv.org/pdf/2202.09495
3. Caleb Robinson — "Solving a game called 'ball sort puzzle'" — https://calebrob.com/algorithms/2023/08/13/ball-sort-puzzle.html
4. tjwood100 — Ball Sort Puzzle Solver (Python, DFS) — https://github.com/tjwood100/ball-sort-puzzle-solver
5. Hacking with Swift — matchedGeometryEffect — https://www.hackingwithswift.com/quick-start/swiftui/how-to-synchronize-animations-from-one-view-to-another-with-matchedgeometryeffect
6. Create with Swift — "Implementing drag and drop with SwiftUI modifiers" — https://www.createwithswift.com/implementing-drag-and-drop-with-the-swiftui-modifiers/
7. SwiftUI Lab — "MatchedGeometryEffect Part 1 (Hero Animations)" — https://swiftui-lab.com/matchedgeometryeffect-part1/
8. hellojoelhuber — SwiftUI Drag-and-Drop library — https://github.com/hellojoelhuber/swiftui-drag-and-drop
9. 2048 SwiftUI (Carlos Corrêa) — GameViewModel + ObservableObject pattern — https://medium.com/flawless-app-stories/2048-swiftui-dda67949beb
10. Kodeco — "How to Make a Game Like Wordle in SwiftUI" — https://www.kodeco.com/31661263-how-to-make-a-game-like-wordle-in-swiftui-part-one
