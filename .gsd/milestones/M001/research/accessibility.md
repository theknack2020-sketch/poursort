# Color Accessibility Research — PourSort

> Research date: 2026-03-22
> Scope: Making a color-sorting puzzle game playable for colorblind users

---

## 1. The Problem

Color vision deficiency (CVD) affects approximately **8% of males and 0.5% of females** worldwide. For a color-sorting puzzle game — where the entire mechanic is distinguishing and grouping colors — this isn't an edge case. It's a core playability issue for roughly 1 in 12 male players.

The three main types of CVD are:

| Type | Deficiency | Prevalence (males) | Confused colors |
|------|-----------|-------------------|-----------------|
| **Deuteranopia** | Green cone missing | ~5% | Red ↔ Green, Brown ↔ Green |
| **Protanopia** | Red cone missing | ~2.5% | Red ↔ Green, Red appears dark/black |
| **Tritanopia** | Blue cone missing | ~0.5% | Blue ↔ Yellow, Blue ↔ Green |
| **Achromatopsia** | Full monochromacy | ~0.003% | All colors → grayscale |

Deuteranopia and protanopia (collectively "red-green colorblindness") account for ~95% of all CVD cases. Tritanopia is rare but important to address.

**Key insight:** A ball sort game with 8-12 colors will have multiple color pairs that are indistinguishable for CVD users — making the game literally unplayable without accommodation.

---

## 2. Solution Strategies

### 2.1 Pattern/Texture Overlays on Balls

The most robust approach: overlay a unique pattern or texture on each ball color, so color is never the sole differentiator.

**How it works:**
- Each color gets a paired pattern: stripes, dots, chevrons, crosshatch, waves, diamonds, etc.
- Patterns are rendered on top of the colored ball as a subtle overlay
- When colorblind mode is active, patterns become more prominent; in normal mode they can be subtle or hidden

**Industry examples:**
- **Puzzle Bobble 3D** (Survios/TAITO): Universal mode replaces all colors with black, white, or patterns. Also offers separate R/G and B/Y modes with adjusted colors.
- **Linx**: Gives each colored line a pattern — yellow lacks a pattern, red is dotted, blue is vertically striped, green is diagonally striped.
- **The Legend of Zelda: Link's Awakening** (2019 Switch): Added square, circle, and triangle shapes to all color-coded elements in the Color Dungeon.
- **Tussie Mussie** (board game): Uses background patterns to double-code card colors.
- **The Isle of Cats** (board game): Different colored cats have unique features — rounded vs. pointy ears, fluffy vs. spiked tails.

**For PourSort — recommended patterns (8 colors):**

| Color | Pattern | Visual description |
|-------|---------|-------------------|
| Red | Horizontal stripes | ═══ |
| Blue | Solid (no pattern) | ● |
| Green | Diagonal stripes (/) | ╱╱╱ |
| Yellow | Dots | ••• |
| Purple | Crosshatch | ╳╳╳ |
| Orange | Vertical stripes | ║║║ |
| Pink | Waves | ∿∿∿ |
| Teal | Chevrons | ⟩⟩⟩ |

**Design considerations:**
- Patterns must be visible at ball size (~30-40pt on iPhone)
- Keep patterns geometric and simple — avoid noise that distracts from gameplay
- Use contrasting colors (white or dark) for pattern strokes to ensure visibility
- Patterns should be attractive enough that some normal-vision users opt in (like League of Legends' colorblind mode, which is popular with all players)

### 2.2 Symbol/Letter-Based Identification

A simpler alternative: stamp each ball with a letter, number, or icon.

**Industry examples:**
- **Ball Sort Puzzle** (Softonic): Accessibility option adds letters to balls for colorblind players. One of the few ball-sort competitors that does this.
- **Puyo Puyo Tetris** (SEGA): Added "Alphabet Puyos" — each colored puyo is shaped as a letter. However, this feature was locked behind earning 100 in-game credits, which is a bad accessibility practice.
- **Flow Free**: Colorblind mode adds letters to colored dots — connect A to A instead of dark-blue to dark-blue.
- **Puzzle Bobble Mini** (Neo Geo Pocket): Had symbol bubbles (star, circle, triangle, etc.) for monochrome mode — the code existed in the game but wasn't exposed as an option on the color version.
- **ColorADD system**: A universal icon system identifying colors, famously used by UNO for its colorblind-accessible version. However, colorblind users report it requires rote memorization and isn't intuitive — "Nothing about a diagonal line 'feels' like yellow."
- **Qwirkle: Color-Blind Friendly Edition**: Features tiles with interior shapes indicating the color.

**For PourSort — recommended symbols:**

| Color | Symbol | SF Symbol name |
|-------|--------|---------------|
| Red | ♦ | `diamond.fill` |
| Blue | ● | `circle.fill` |
| Green | ▲ | `triangle.fill` |
| Yellow | ★ | `star.fill` |
| Purple | ■ | `square.fill` |
| Orange | ⬡ | `hexagon.fill` |
| Pink | ♥ | `heart.fill` |
| Teal | ✦ | `sparkle` |

**Tradeoffs:**
- ✅ Simplest to implement
- ✅ Clearest differentiation — no ambiguity
- ❌ Can feel "clinical" and reduce visual appeal
- ❌ Small symbols on small balls may be hard to read
- ❌ Every game reinvents its own mapping, so users must re-learn per game

**Recommendation:** Offer symbols as one mode option, but prefer patterns as the default colorblind mode since they feel more integrated into the visual design.

### 2.3 Colorblind-Safe Palettes

Rather than adding secondary indicators, choose colors that remain distinguishable across all CVD types.

#### Okabe-Ito Palette (Gold Standard)

Proposed by Masataka Okabe and Kei Ito (2008) at the University of Tokyo. Recommended by Nature, Science, and Cell journals. 8 colors that remain distinguishable for protanopia, deuteranopia, and tritanopia. Has distinct luminance values so the palette works even in grayscale.

```
Orange:         #E69F00
Sky Blue:       #56B4E9
Bluish Green:   #009E73
Yellow:         #F0E442
Blue:           #0072B2
Vermillion:     #D55E00
Reddish Purple: #CC79A7
Black:          #000000
```

**Suitability for PourSort:** Good starting point for up to 8 colors. Swap Black for a dark gray since black may blend with dark backgrounds. Yellow (#F0E442) may need adjustment — it can be hard to see on white/light backgrounds.

#### Paul Tol Palettes

Offer more options for larger color counts:
- **Bright** (7 colors): `#4477AA, #66CCEE, #228833, #CCBB44, #EE6677, #AA3377, #BBBBBB`
- **Vibrant** (7 colors): `#0077BB, #33BBEE, #009988, #EE7733, #CC3311, #EE3377, #BBBBBB`

#### Key Palette Design Rules

1. **Vary luminance, not just hue.** CVD users can still distinguish light from dark. If all your colors are the same brightness, they'll merge.
2. **Avoid pure red/green pairs.** The most common confusion axis.
3. **Magenta + green is the universal safe pair.** It works for all three single-cone deficiencies because green is mid-spectrum and magenta combines red and blue (opposite spectrum edges).
4. **Orange/blue is NOT universally safe.** Works for deuteranopia/protanopia but fails for tritanopia.
5. **Test with simulators.** Tools: Color Oracle (desktop app), Coblis (web), Viz Palette, or the Xcode Accessibility Inspector.

#### Recommended PourSort Palette (CVD-optimized)

Designed for max 8 distinguishable ball colors across all CVD types:

```swift
// PourSort colorblind-optimized palette
static let ballColors: [String: Color] = [
    "blue":      Color(hex: "#0072B2"),  // Blue (safe across all)
    "orange":    Color(hex: "#E69F00"),  // Orange (distinct luminance)
    "green":     Color(hex: "#009E73"),  // Bluish green (not pure green)
    "vermillion":Color(hex: "#D55E00"),  // Vermillion (not pure red)
    "skyBlue":   Color(hex: "#56B4E9"),  // Sky blue (light, high luminance)
    "purple":    Color(hex: "#CC79A7"),  // Reddish purple / pink
    "yellow":    Color(hex: "#F0E442"),  // Yellow (unique luminance)
    "darkGray":  Color(hex: "#555555"),  // Dark gray (replaces black)
]
```

**When more than 8 colors are needed (harder levels):** This is where patterns/symbols become mandatory. No palette of 10+ colors is reliably distinguishable across all CVD types. Beyond 8, add secondary encoding.

---

## 3. Apple's `accessibilityDifferentiateWithoutColor` API

### What It Is

A system-level iOS setting under **Settings → Accessibility → Display & Text Size → Differentiate Without Color**. When enabled, it signals to apps that the user needs non-color differentiation.

### SwiftUI Integration

```swift
struct BallView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    let ballColor: BallColor
    
    var body: some View {
        Circle()
            .fill(ballColor.color)
            .overlay {
                if differentiateWithoutColor {
                    // Show pattern or symbol overlay
                    Image(systemName: ballColor.symbolName)
                        .foregroundStyle(.white)
                        .font(.caption)
                }
            }
    }
}
```

### How to Test

- **Simulator:** Settings app → Accessibility → Display & Text Size → Differentiate Without Color
- **Xcode Accessibility Inspector:** Third tab (Settings icon) has a toggle
- **Device:** Settings → Accessibility → Display & Text Size → Differentiate Without Color

### Recommended Behavior

| Setting state | PourSort behavior |
|--------------|-------------------|
| OFF + no in-app setting | Default colors, no overlays |
| OFF + user enables in-app "Colorblind Mode" | Adjusted palette + pattern overlays |
| ON (system) | Automatically activate pattern overlays, regardless of in-app setting |

**Key principle:** Respect the system setting automatically, but also provide an in-app toggle. Some colorblind users don't know about or don't use the system setting. Don't make accessibility opt-in only through an obscure OS setting.

### Related Environment Values

```swift
@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
@Environment(\.accessibilityReduceTransparency) var reduceTransparency
@Environment(\.accessibilityInvertColors) var invertColors
@Environment(\.accessibilityReduceMotion) var reduceMotion
```

---

## 4. Competitor Analysis: How Ball Sort Games Handle Colorblindness

### The landscape is bad.

Most ball-sort and color-sorting puzzle games on the App Store have **zero** accessibility support:

| App | Colorblind support | App Store accessibility declaration |
|-----|-------------------|-------------------------------------|
| **Ball Sort - Color Puzzle Games** (Longwind Studio) | None mentioned | Not declared |
| **Ball Sort Puzzle: Color Bubble** (Topsmart) | None | "Developer has not yet indicated which accessibility features" |
| **Ball Sort: Color Sort Puzzle** (various) | None | "Developer has not yet indicated which accessibility features" |
| **Color Ball Sort Puzzle** (Sonat) | None | "Developer has not yet indicated which accessibility features" |
| **Ball Sort - Color Game Puzzle** (another) | None | "Developer has not yet indicated which accessibility features" |
| **Ball Sort Puzzle** (Softonic-reviewed) | **Letters on balls** | One of the few with any support |
| **Block Sort: Color Puzzle Games** (Guru) | Claims "colorblind friendly" | Vague — not described how |
| **Bubble Blend: Ball Sort Puzzle** | **2 colorblind profiles** | Explicitly listed |

**Summary:** Out of the top ~10 ball sort apps on iOS, only **1-2** offer any colorblind accommodation, and those that do typically just add letters — no patterns, no palette adjustment, no system setting integration. Most don't even declare accessibility features in their App Store listing.

### Puzzle Bobble 3D: Best-in-class Example

Puzzle Bobble 3D: Vacation Odyssey (Survios/TAITO) is the gold standard for bubble-puzzle accessibility. They offer three modes:
- **R/G mode:** Adjusted palette for red-green confusion (deuteranopia/protanopia)
- **B/Y mode:** Adjusted palette for blue-yellow confusion (tritanopia)
- **UNI (Universal) mode:** All colors replaced with black, white, and patterns — works for all CVD types including monochromacy

They consulted extensively with colorblind playtesters during development.

### Other Notable Games

- **Dungeons of Aether:** Offers deuteranopia, tritanopia, protanopia, AND Okabe-Ito palette options
- **League of Legends:** Colorblind mode changes health bars and particle colors — so popular that normal-vision players use it
- **Battlefield 4:** Changes specific UI element colors per CVD type without applying a whole-screen filter — considered best practice

---

## 5. Recommended Implementation Plan for PourSort

### Tier 1: Launch (MVP Accessibility)
1. **Use Okabe-Ito derived palette** as the base color set (max 8 colors)
2. **Respect `accessibilityDifferentiateWithoutColor`** — auto-enable symbol overlays when system setting is ON
3. **Add in-app "Colorblind Mode" toggle** in Settings (independent of system setting)
4. When colorblind mode is active: overlay SF Symbols on each ball

### Tier 2: Post-Launch Enhancement
5. **Add pattern overlays** as an alternative to symbols (user preference: Off / Symbols / Patterns)
6. **CVD-specific palette options:** Deuteranopia, Protanopia, Tritanopia presets that remap only the problematic colors
7. **Universal/High Contrast mode:** Black, white, and patterns only (monochromacy support)

### Tier 3: Polish
8. **Custom color picker** letting users assign their own colors per group
9. **Haptic differentiation** — subtle haptic variations when picking up balls of different colors (for users who can't see the color but can feel the vibration pattern)
10. **Test with actual colorblind users** before release

### Implementation Architecture

```
Settings
├── colorblindMode: enum { off, auto, symbols, patterns, universal }
├── cvdType: enum { none, deuteranopia, protanopia, tritanopia }  
└── customColors: [BallColor: Color]?

Ball Rendering Pipeline
1. Get base color from palette (adjusted if cvdType != none)
2. If colorblindMode == .auto, check @Environment differentiateWithoutColor
3. If overlays needed, render pattern/symbol layer on top
4. Apply to ball shape with appropriate blend mode
```

---

## 6. Key Takeaways

1. **This is a competitive advantage.** The vast majority of ball-sort competitors ignore colorblind users entirely. Even basic accommodation would differentiate PourSort.

2. **Don't rely on color filters alone.** Whole-screen color filters (like DOOM's deuteranopia mode) make everything look washed out and often make things worse. Per-element adjustments (patterns, symbols, or palette swaps) are far superior.

3. **Never gate accessibility behind unlockables.** Puyo Puyo Tetris locked its Alphabet Puyos behind 100 credits. Don't do this. Accessibility features should be available from first launch.

4. **Patterns > Letters > Filters**, in order of user experience quality. Patterns feel integrated and attractive; letters work but feel clinical; filters are lazy and often counterproductive.

5. **8 colors is the practical ceiling** for colorblind-safe palettes. Beyond that, secondary encoding (patterns/symbols) becomes mandatory regardless of palette choice.

6. **Respect the system setting AND provide in-app controls.** Not all colorblind users enable the system accessibility setting.

7. **Mention it in the App Store listing.** Declaring accessibility features in the App Store metadata is both good practice and marketing — colorblind users actively search for games that accommodate them.

---

## Sources

1. Chris Fairfield — "Unlocking Colorblind Friendly Game Design" — https://chrisfairfield.com/unlocking-colorblind-friendly-game-design/
2. AbleGamers — "Unlocking Colorblind Accessibility in Puzzle Games" — https://ablegamers.org/unlockingaccessibilitypuzzlegames/
3. Colorblind Games — "Universal Colorblind Code?" — https://colorblindgames.com/2023/04/19/universal-colorblind-code/
4. Calliope Games — "Making Board Games Accessible for Color Blind Players" — https://calliopegames.com/9699/accomodations-for-color-blind-players/
5. Survios — "Puzzle Bobble 3D Accessibility Modes" — https://survios.com/studio/color-blindness-accessibility-modes-revealed-for-puzzle-bobble-3d-vacation/
6. TV Tropes — "Colorblind Mode" — https://tvtropes.org/pmwiki/pmwiki.php/Main/ColorblindMode
7. Gamers Experience — "Colorblind accessibility in video games" — https://www.gamersexperience.com/colorblind-accessibility-in-video-games-is-the-industry-heading-in-the-right-direction/
8. Filament Games — "Color Blindness Accessibility in Video Games" — https://www.filamentgames.com/blog/color-blindness-accessibility-in-video-games/
9. Hacking with Swift — "Supporting specific accessibility needs with SwiftUI" — https://www.hackingwithswift.com/books/ios-swiftui/supporting-specific-accessibility-needs-with-swiftui
10. Mobile A11y — "SwiftUI Accessibility: User Settings" — https://mobilea11y.com/guides/swiftui/swiftui-settings/
11. Okabe & Ito (2008) — "Color Universal Design" — https://jfly.uni-koeln.de/color/
12. Conceptviz — "Okabe-Ito Palette: Complete Reference" — https://conceptviz.app/blog/okabe-ito-palette-hex-codes-complete-reference
13. GitHub Discussion — "Colorblind scheme inaccessible for tritanopia" — https://github.com/orgs/community/discussions/6385
14. Apple Developer Documentation — `accessibilityDifferentiateWithoutColor` — https://developer.apple.com/documentation/swiftui/environmentvalues/accessibilitydifferentiatewithoutcolor
