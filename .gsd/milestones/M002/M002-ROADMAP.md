# M002: PourSort MVP Build

**Vision:** Ship a clean, ad-free color sorting puzzle game with 500+ levels to the App Store.

## Success Criteria

- Player can tap tubes to move balls and solve puzzles
- All levels are algorithmically generated and verified solvable
- Difficulty progresses smoothly from 3 colors to 10 across 5 worlds
- Animations feel satisfying (spring physics, haptic feedback)
- Colorblind players can play with symbol overlays
- Pro unlock IAP works in StoreKit sandbox
- Daily challenge generates same puzzle for all players on same date
- App builds, archives, uploads to ASC via CLI

## Key Risks / Unknowns

- Level generator producing unsolvable puzzles — must verify with solver
- matchedGeometryEffect performance with 40+ balls on screen
- Difficulty curve feeling monotonous after 200+ levels

## Slices

- [ ] **S01: Game Engine & Core Gameplay** `risk:high` `depends:[]`
  > After this: player can tap tubes, balls animate between tubes, win detection works, 10 hardcoded test levels playable

- [ ] **S02: Level Generator & Solver** `risk:high` `depends:[S01]`
  > After this: 500+ levels auto-generated, all verified solvable, organized into 5 worlds with progressive difficulty

- [ ] **S03: UI Polish & Accessibility** `risk:medium` `depends:[S01]`
  > After this: glass tube rendering, radial gradient balls, haptics, colorblind symbol overlays, dark mode, level select screen

- [ ] **S04: IAP & Daily Challenge** `risk:medium` `depends:[S01,S02]`
  > After this: Pro unlock $4.99, free/pro feature gates, daily challenge with date-based seed, share card

- [ ] **S05: App Icon & Branding** `risk:low` `depends:[S01]`
  > After this: amber/orange app icon, accent colors applied, visual identity complete

- [ ] **S06: Integration, Screenshots & Launch** `risk:medium` `depends:[S01,S02,S03,S04,S05]`
  > After this: app builds with 0 warnings, archives via CLI, uploads to ASC, screenshots captured, submitted for review

## Boundary Map

### S01 → S02
Produces:
- GameState model (tubes, balls, colors)
- Move validation and win detection logic
- Level data structure (LevelConfig)

### S01 → S03
Produces:
- TubeView and BallView components
- Basic tube/ball rendering

### S01 → S04
Produces:
- LevelConfig structure for daily challenge seeding
- Game completion callback

### S02 → S04
Produces:
- LevelGenerator that accepts a seed parameter
