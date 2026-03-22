# Decisions

| ID | Scope | Decision | Choice | Rationale |
|----|-------|----------|--------|-----------|
| D001 | architecture | App name | PourSort | Unique on App Store, describes the mechanic (pour + sort) |
| D002 | architecture | No ads policy | Never — premium only | Core differentiator, competitor pain point #1 |
| D003 | architecture | Tech stack | SwiftUI + SwiftData + StoreKit 2 | Same as Lumifaste/AquaFaste, proven |
| D004 | architecture | Level generation | Algorithmic (seed-based) | 1000+ levels with no manual design, deterministic and solvable |
| D005 | architecture | Bundle ID | com.theknack.poursort | Consistent with family |
| D006 | architecture | Game engine | Pure SwiftUI (no SpriteKit) | Simpler, same codebase pattern as other apps |
