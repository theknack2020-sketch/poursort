# S01 Plan — Game Engine & Core Gameplay

## Objective
Build the core ball sort game engine: data models, move logic, win detection, tube rendering, ball animations, and basic playable UI with test levels.

## Tasks

- [ ] **T01: Project Setup** `est:10m`
  - XcodeGen project.yml (iOS 17+, SwiftUI)
  - Color+Theme extension (amber/orange palette, dark-mode-first)
  - App entry point
  - Generate .xcodeproj, verify build

- [ ] **T02: Game Models** `est:20m`
  - Ball: id (UUID), color (BallColor enum)
  - BallColor: 10 colors with hex values, SF Symbol for accessibility
  - Tube: id, balls array, capacity
  - GameState: tubes array, move validation, win check
  - LevelConfig: colorCount, tubeCount, emptyTubes, capacity, seed
  - Move: fromTube, toTube (for undo stack)

- [ ] **T03: Game Logic** `est:20m`
  - canMove(from, to) — top ball matches or empty, not full
  - performMove(from, to) — move ball, push to undo stack
  - undo() — pop from stack, reverse move
  - isComplete() — every non-empty tube is full and monochromatic
  - restart() — reset to initial state

- [ ] **T04: Tube & Ball Views** `est:30m`
  - TubeView: glass container (rounded rect, subtle border)
  - BallView: circle with radial gradient, color
  - matchedGeometryEffect for ball movement animation
  - Tap interaction: first tap selects source, second tap moves
  - Selected tube highlight

- [ ] **T05: Game Board View** `est:20m`
  - GameBoardView: grid layout of tubes (adaptive columns)
  - Top bar: level number, move count
  - Bottom bar: undo button, restart button, extra tube button
  - Win detection → celebration overlay
  - 10 hardcoded test levels for verification

- [ ] **T06: Navigation** `est:15m`
  - HomeView: play button, level select, settings stub
  - Level flow: HomeView → GameBoardView → win → next level
  - Level progress in UserDefaults (currentLevel)

## Verification
- xcodebuild succeeds with 0 errors
- App launches showing home screen
- Can play through test levels by tapping tubes
- Ball animations smooth between tubes
- Win detection triggers on completion
- Undo reverses last move correctly
