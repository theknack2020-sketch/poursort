# Visual Design Research — Color Sort Puzzle Games

> **Research Date:** March 22, 2026
> **Scope:** UX & visual design patterns of top-performing ball sort / water sort / color sort puzzle games on iOS & Android
> **Purpose:** Establish a visual design direction for PourSort that stands out in a saturated market

---

## Executive Summary

The color sort genre is visually homogeneous. Nearly every top game uses the same layout, the same color choices, and the same celebration patterns. The market is ripe for a game that applies real design craft instead of the stock-template aesthetic that dominates the category. PourSort's visual opportunity is to be the **Wordle of ball sort** — minimalist, premium-feeling, and confident — while every competitor looks like a free-to-play ad farm.

---

## 1. Tube Layout Patterns

### How Competitors Arrange Tubes

**Single Row (most common, ≤6 tubes):**
- Tubes aligned horizontally across the middle-to-lower third of the screen
- Equal spacing, centered on screen width
- Simple and clean, but breaks down at 7+ tubes as tubes become too narrow

**Two Rows (7–12 tubes):**
- Top row and bottom row, typically staggered or aligned
- Water Sort Puzzle (IEC Global) shifts to two rows at ~level 50+ when tube count exceeds 7
- Row spacing is usually tight — tubes in top row are visually distinct from bottom row via vertical gap
- Ball Sort Puzzle places tubes against a landscape background scene (forest, mountains, sunset)

**Grid Layout (12+ tubes):**
- Rare in ball sort, more common in nut/bolt sort variants (Nut Sort by Tripledot Studios)
- Nut Sort uses vertical bolts on a flat surface viewed from slight 3D angle
- Grid becomes cluttered — most games avoid going past 14 tubes

**Scrollable Layout (rare):**
- Some games allow horizontal scrolling for very wide levels
- Generally considered poor UX — players lose sight of available tubes

### Tube Positioning Observations

| Game | Max Tubes | Layout | Tube Shape | Background |
|------|-----------|--------|------------|------------|
| Water Sort Puzzle | 14+ | 2 rows | Rounded-bottom glass flask | Solid gradient (light blue) |
| Ball Sort Puzzle (Sergey Dmitriev) | 12+ | 2 rows | Cylindrical test tubes | Nature landscape (forest/dusk sky) |
| Ball Sort Puzzle (Guru Smart) | 12+ | 2 rows | Glass tubes with rounded bottom | Dark gradient / themed |
| Color Sort 3D | 10 | 2 rows (3D perspective) | 3D cylindrical | 3D wooden table surface |
| Nut Sort (Tripledot) | 10+ bolts | Grid | Vertical bolts/pegs | Flat island scene |
| Colorwood Sort | 8 | 2 rows | Wooden pegs | Wooden table |
| Hexa Stack | N/A (hex grid) | Hexagonal board | Hex cells | Minimal solid color |

### Layout Best Practices

1. **1–6 tubes**: Single horizontal row, centered, each tube 50–60pt wide
2. **7–10 tubes**: Two rows, top row centered, bottom row centered — tubes ~50pt wide
3. **11–14 tubes**: Two rows, tighter spacing (~44pt tubes), or slight horizontal scroll
4. **Tube height**: 4-ball capacity = ~200pt; 5-ball = ~240pt
5. **Tap targets**: Minimum 44pt wide per Apple HIG (most competitors meet this)
6. **Vertical placement**: Tubes sit in the bottom 60% of screen; top 40% reserved for level info, UI controls, and breathing room

### PourSort Recommendation

Use a **dynamic grid** that adapts cleanly:
- **Single centered row** for levels with ≤7 tubes
- **Two rows** for 8–14 tubes, with the bottom row containing 1 more tube than the top row (visual pyramid stability)
- Generous spacing — don't cram. Let tubes breathe.
- Tubes should sit on a subtle "surface" (a slight shadow or ground line) to anchor them visually

---

## 2. Color Palettes Used by Competitors

### Common Color Sets

Most games use a core set of **7–12 highly saturated colors** chosen for maximum visual distinction. Across the top 20 competitors, these are the near-universal colors:

| Color | Usage Frequency | Notes |
|-------|----------------|-------|
| Red | ~100% | Always present; primary anchor color |
| Blue (medium) | ~100% | Always present |
| Green | ~95% | Usually a kelly/lime green, sometimes teal |
| Yellow | ~95% | Bright, high-luminance yellow |
| Orange | ~90% | Warm, distinct from both red and yellow |
| Purple/Violet | ~90% | Usually a rich grape or violet |
| Pink | ~85% | Hot pink or rose, sometimes confused with red |
| Light Blue/Cyan | ~80% | Cyan or sky blue, distinct from medium blue |
| Dark Green/Teal | ~60% | Added for advanced levels |
| Brown | ~50% | Earth tone for variety |
| Gray | ~40% | Low-saturation neutral |
| Dark Blue/Navy | ~30% | Hard to distinguish from medium blue in some games |

### Color Problems Identified in Reviews

User reviews surface a consistent complaint: **colors are too similar**, especially at higher difficulty levels.

- Nut Sort users reported confusion between red and orange, leading one player to discover they were colorblind
- Ball Sort Puzzle players at level 300+ report "slight variations in the shades of the colors" that are deliberately hard to distinguish
- Water Sort Puzzle reviews mention light blue vs. dark blue, and red vs. pink as common confusion pairs
- Color Water Sort Puzzle 3D user complained about "wavy, unsymmetrical tubes" making color reading harder

### Competitor Colorblind Accessibility

- **Nut Sort (Tripledot):** Offers purchasable pattern-overlay nut designs in the shop
- **Most competitors:** Zero colorblind support. No patterns, no labels, no accessibility settings
- **Water Sort Puzzle:** No colorblind mode whatsoever
- **Ball Sort Puzzle (Guru Smart):** No colorblind mode

### PourSort Recommendation: Color Palette

Use the **10-color palette from animation-ux.md research** (Ruby, Tangerine, Sunflower, Emerald, Ocean, Sky, Violet, Rose, Mint, Slate) — optimized for:
- Maximum perceptual distance between pairs
- Colorblind safety (avoids pure red-green adjacent confusion)
- Vibrancy without eye fatigue

**Additional principles:**
- Never introduce two colors that differ only in lightness (no "dark blue" + "blue")
- Colorblind mode ON by default if system `accessibilityDifferentiateWithoutColor` is true
- Pattern overlays: stripes, dots, crosses, diamonds, stars, rings, chevrons, waves
- Each ball color gets a unique secondary pattern that appears subtly even in standard mode (like Wordle's high-contrast mode)

---

## 3. Level Progress Indicators

### How Competitors Show Progress

**Level Number Display (universal):**
- Every game shows "Level X" prominently at the top of the gameplay screen
- Usually centered, medium-weight font, white or dark text depending on background

**Level Map / World Map (common in top titles):**
- Water Sort Puzzle: Linear node-based path (like Candy Crush Saga). Nodes connected by a winding line. Current level highlighted. Completed levels show a checkmark. Scrollable vertically.
- Ball Sort Puzzle (Guru Smart): Similar node map with decorative themed zones (beach, forest, mountain) every 20-50 levels
- Water Sort: Color Tube Puzzle (FlyFox): Hidden story fragments revealed as you progress — progress doubles as narrative advancement
- Nut Sort: Island scenes that unlock as you complete levels — visual diary of progress

**Star Rating (common):**
- 1–3 stars awarded per level based on moves used or time
- Stars accumulate to unlock bonus content or cosmetics
- Water Sort Puzzle doesn't use stars — just binary pass/fail
- Ball Sort Puzzle awards stars that unlock seasonal ball skins

**Progress Bar (less common):**
- Some games show a small progress bar on the level select screen indicating "X% of levels completed"
- Color Water Sort 3D: Progress bar fills across a scene image

**Chapter/Zone System:**
- Games bundle 20–50 levels into thematic "chapters" or "worlds"
- New chapters unlock with unique backgrounds, music, or cosmetic themes
- Creates milestones within the grind

**Plant Growth System (emerging trend):**
- Water Sort! Color Logic Puzzle: Each completed level grows a virtual plant
- Plant stages (sprout → leaves → bloom) act as a visual progress tracker
- Ties emotional satisfaction to consistent play

### PourSort Recommendation

1. **Simple level counter** at the top — "Level 47" — clean, no clutter
2. **Chapter milestones** every 25 levels with distinct visual themes (background color/pattern shifts)
3. **No star system** — binary pass/fail keeps it clean and low-anxiety
4. **Minimal progress bar** on the level-select screen showing chapter progress (e.g., "12/25" with a subtle fill bar)
5. Consider a light "journey" metaphor — but keep it abstract/geometric, not a literal map

---

## 4. Celebration Animations

### What Competitors Do

**Confetti (near-universal):**
- Ball Sort Puzzle: "Whenever they sort one color of balls, a test tube shoots colored confetti"
- Water Sort Puzzle: "Confetti flying around" mentioned in positive reviews as a feel-good moment
- Both per-tube completion (small burst when a tube is finished) and level completion (big burst) confetti are common

**Per-Tube Completion:**
- Tube full of one color → small confetti burst from the tube mouth
- Some games add a checkmark or lid that appears on completed tubes
- Color flash on the tube (brief white overlay)
- Tube may "lock" with a subtle animation (a seal or cap slides on)

**Level Completion:**
- Full-screen confetti explosion (center origin, spreading outward)
- "Level Complete" or "Congratulations" text scales/bounces in
- Haptic feedback (success pattern)
- Star rating display (if applicable)
- "Next Level" button appears after ~2s delay
- Some games auto-advance after a short pause

**Chapter Completion (milestone):**
- Amplified confetti (more particles, longer duration)
- Special celebration screen with reward summary
- Unlock notification for new cosmetics/themes
- Some games show brief fireworks or sparkle animations

**Weak Patterns to Avoid:**
- Overly long celebrations that delay gameplay (>3 seconds)
- Forced ad after every level completion celebration — ruins the dopamine hit
- Generic stock confetti that doesn't match the game's color palette

### PourSort Recommendation

Match the celebration sequence from animation-ux.md research:
1. **Per-tube completion**: Subtle burst + haptic tap — don't interrupt gameplay flow
2. **Level completion**: Confetti burst (game palette colors), haptic success, "Level Complete" text with spring animation
3. **Chapter completion** (every 25 levels): Amplified celebration with extended confetti
4. **Key principle**: Celebrations should feel earned but not delay progression. 2–2.5 seconds total, then "Next" button is available.

---

## 5. Menu & Settings Design

### Competitor Menu Patterns

**Home Screen:**
- Universally simple: a large "Play" or "Continue" button dominates the center
- Level number shown prominently
- Settings gear icon (top-left or top-right)
- Some games add: daily reward button, event/tournament banner, shop button, no-ads purchase prompt
- Background matches gameplay theme

**Settings Screen:**
- Typically a modal overlay or popup, not a full-screen transition
- Common settings: Sound on/off, Music on/off, Vibration on/off, Restore purchases, Rate app, Privacy policy
- No-ads purchase is often surfaced in settings as well
- Most games have 5–8 settings maximum
- UI style: rounded rectangles for toggles, simple icon + label rows

**Level Select:**
- Scrollable vertical list of level nodes (linear path) or a simple grid
- Completed levels marked with a checkmark or colored differently
- Current level is highlighted/enlarged
- Some games gate level select behind completion — you must play sequentially

**Pause Screen:**
- Overlay dimming the game board
- Resume, Restart, Quit buttons
- Sometimes hint/undo tools accessible here
- Minimal — 3 buttons maximum

### Visual Style of Menus

| Pattern | Frequency | Notes |
|---------|-----------|-------|
| Flat/Minimal | ~60% | Clean backgrounds, simple shapes, sans-serif fonts |
| Rounded cards/panels | ~50% | White or frosted cards for menu items |
| Gradient backgrounds | ~40% | Soft gradients (light blue → white, purple → blue) |
| Illustrated/themed | ~30% | Nature scenes, wooden textures, cartoon elements |
| Dark/moody | ~15% | Dark theme as an option or default |
| Glass/blur effects | ~10% | Modern iOS-style frosted glass |

### PourSort Recommendation

- **Home screen**: Minimalist. Title, level number, "Play" button, gear icon. No clutter, no event banners, no shop button. Premium confidence.
- **Settings**: Modal sheet with iOS-native feel. Toggle rows for Sound, Haptics, Colorblind Mode. Links for Rate App, Privacy Policy, Restore Purchases.
- **Pause**: Frosted glass overlay. Resume, Restart, Menu buttons. Clean and fast to dismiss.
- **Visual vocabulary**: Use `.ultraThinMaterial` glass effects, generous whitespace, SF Pro font, rounded corners. Let the gameplay be the visual star.

---

## 6. 2D vs. 3D Ball Rendering — Comparison

### 2D Flat (Minority approach)

**How it looks:** Solid colored circles, sometimes with a slight border. No gradients, no depth cues.

| Pros | Cons |
|------|------|
| Clean, fast to render | Looks cheap/generic |
| Works well at small sizes | No tactile appeal |
| Clear color reading | Less satisfying to interact with |
| Low GPU load | Doesn't stand out on App Store |

**Who uses it:** Hexa Stack, some web-based clones, ultra-minimal games

### 2D with Depth Cues (Most common approach)

**How it looks:** Colored circles with a radial gradient (lighter highlight spot in upper-left, darker shadow in lower-right), a small specular highlight (white dot), and a drop shadow.

| Pros | Cons |
|------|------|
| Reads as spherical/3D while being computationally cheap | Overused — visually identical across 80%+ of competitors |
| Good color readability | Slight learning curve to render well |
| Satisfying visual weight | Can look like clip-art if poorly executed |
| Works at all ball sizes | |

**Who uses it:** Water Sort Puzzle, Ball Sort Puzzle (Sergey Dmitriev), Ball Sort - Color Puzzle Games, most major titles

**Typical rendering technique:**
- `RadialGradient` with highlight offset to upper-left
- White specular dot overlay at ~30% opacity
- Drop shadow (color-tinted, offset y+2, blur 3–4)
- This is exactly what the animation-ux.md `BallView` code implements

### Full 3D Rendered (Growing trend)

**How it looks:** Pre-rendered or real-time 3D spheres with realistic lighting, reflection, environment mapping. Tubes shown with 3D perspective.

| Pros | Cons |
|------|------|
| Eye-catching App Store screenshots | Higher GPU/battery cost |
| Premium feel | Harder to read colors at small sizes |
| ASMR-satisfying pour animations | 3D perspective can create tap-target confusion |
| Modern look stands out | Heavier asset pipeline |
| Differentiation vs 2D crowd | Can feel gimmicky if not polished |

**Who uses it:** Color Sort 3D — Hoop Puzzle (Zephyr Mobile), Color Water Sort Puzzle 3D, Color Water Sort 3D (CrazyGames), Color Sort 3D (Matching Game)

**3D-specific UI patterns:**
- Camera is angled ~30° above horizontal, looking down at the tubes on a surface
- Tubes rendered as transparent glass cylinders with refraction
- Balls/liquid have reflective surfaces
- Pour animation shows liquid flowing between tubes with fluid dynamics
- Background is a 3D environment (table, room, garden)
- One user described 3D experience: "The 3D colors are beautiful and sorting them into the right tubes is so incredibly satisfying"

**3D-specific problems:**
- Users complain about "wavy, unsymmetrical tubes" making it harder to judge colors
- 3D perspective can make it unclear which tube is "behind" another
- Heavier apps drain battery faster
- Some 3D games have noticeable frame drops on older devices

### Emerging: "2.5D" Hybrid

Some newer games use a flat 2D top-down layout with 3D-rendered balls (pre-rendered assets or shaders). This gets the visual appeal of 3D without the perspective confusion.

### PourSort Recommendation: 2D with Premium Depth Cues

Go with **2D layout + enhanced depth-cue balls** (the `BallView` approach from animation-ux.md). Rationale:

1. **Performance**: Pure SwiftUI, no SceneKit/Metal overhead. Runs at 120fps on all devices.
2. **Clarity**: Top-down 2D layout means no perspective confusion. Every tube is equally accessible.
3. **Color readability**: 2D balls with radial gradients are the clearest for color identification — critical for a game about color.
4. **Polish ceiling is high**: With proper gradients, specular highlights, drop shadows, and spring animations, 2D balls can look gorgeous. The problem with competitors isn't 2D itself — it's lazy 2D.
5. **Differentiation through design quality, not rendering technique**: Most 2D competitors use stock-template art. PourSort can stand out by executing 2D rendering at a premium level — think the visual gap between a generic calculator app and Apple's Calculator.

**Enhancement opportunities:**
- Subtle glass refraction on tubes (`.ultraThinMaterial` + overlay gradients)
- Color-accurate shadows under each ball (tinted by ball color)
- Micro-shimmer on idle balls (ambient `phaseAnimator`)
- Tube liquid level rendering (for the "water sort" variant feel) — even if using balls, a thin gradient "glow" at the tube bottom where balls rest

---

## 7. Visual Styles That Stand Out in the Market

### What the Market Looks Like

The vast majority of color sort games fall into two visual camps:

**Camp A — Stock Casual (70% of market):**
- Bright gradient backgrounds (light blue, pink, purple)
- Generic rounded UI elements
- Cartoonish, high-saturation everything
- Looks like it was built from a Unity asset pack in a weekend
- Example: Most Google Play water sort clones

**Camp B — Nature/Cozy Theme (20% of market):**
- Forest/mountain/sunset landscape backgrounds
- Wooden textures on tubes or surfaces
- Warm, earthy color palette for UI (not gameplay colors)
- Seasonal updates with holiday themes
- Example: Ball Sort Puzzle (forest background), Colorwood Sort (wooden theme)

**Camp C — 3D/Premium (10% of market):**
- 3D rendered environments
- Realistic glass/liquid materials
- Camera perspective looking down at a surface
- Higher production value but often at the cost of clarity
- Example: Color Sort 3D, Color Water Sort Puzzle 3D

### What's Missing

Nobody in the market is doing:
- **Truly minimal design** with confident use of whitespace (à la Wordle, Alto's Odyssey)
- **Dark-mode-first design** that feels premium and reduces eye fatigue
- **Sophisticated typography** — every competitor uses generic sans-serif fonts
- **Systematic visual language** — consistent corner radii, spacing, color relationships
- **Motion design as a first-class feature** — competitors have animation, but it's utilitarian, not delightful
- **A visual identity that says "I'm not a free-to-play ad farm"**

### Design Opportunities for PourSort

#### Strategy: Premium Minimalism

Position PourSort as the **premium, design-forward** entry in the color sort genre. The visual language should communicate:
- "This app respects your time and attention"
- "This was made by people who care about craft"
- "This is worth paying for"

#### Specific Visual Differentiators

**1. Dark-Mode-First with Adaptive Light Mode**
- Default to a rich dark background (not pure black — use a deep blue-charcoal: `#0D1117`)
- Balls glow subtly against the dark background — colors POP
- Glass tubes are rendered as translucent shapes with edge highlights
- Light mode is available but dark is the signature look
- No competitor leads with dark mode; most offer it as an afterthought

**2. Generous Whitespace (Darkspace)**
- Tubes don't crowd the screen. There's room to breathe.
- UI elements are minimal — no banner ads, no event popups, no shop buttons
- The game board is the hero. Everything else recedes.
- Competitors cram the screen with buttons, banners, currency displays, and ad slots

**3. Typography**
- SF Pro Rounded for UI labels (warm, approachable)
- Level numbers in a large, bold, confident weight
- No decorative/cartoon fonts — clean and modern
- Track level titles with generous letter-spacing for elegance

**4. Signature Pour Animation**
- The ball-pour arc is the game's signature moment. Make it feel like pouring a perfect espresso shot — smooth, weighty, satisfying.
- Spring animations with real inertia, squash-and-stretch on landing
- Staggered multi-ball pours that cascade like dominoes
- This is where PourSort's visual identity lives — in the feel of the pour

**5. Ambient Micro-Animations**
- Idle balls have a subtle breathing shimmer (phaseAnimator)
- Selected tube has a gentle glow pulse
- Background has ultra-slow parallax or gradient drift
- These micro-motions make the app feel alive without being distracting

**6. Sound as Visual Design**
- Soft, satisfying "tok" when a ball lands
- Gentle glass chime when a tube completes
- Crisp confetti rustle on level complete
- No music by default — let the sound effects carry the ASMR quality
- This is increasingly a differentiator: "satisfying ASMR sounds" is mentioned in multiple competitor descriptions

**7. Seasonal Without Being Garish**
- Subtle seasonal accent colors rather than full reskins
- A spring theme might shift the background from deep charcoal to a warm midnight blue, not paste flowers everywhere
- Holiday events are optional, not interruptive

### Visual Identity Summary

| Attribute | PourSort | Typical Competitor |
|-----------|----------|-------------------|
| Background | Rich dark (charcoal/navy) | Bright gradient or nature scene |
| Ball style | Premium 2D with radial gradient + specular + color shadow | Flat or basic gradient |
| Tube style | Frosted glass (`.ultraThinMaterial`) with edge glow | Plain outlined rectangles or basic 3D |
| Animation | Spring-based physics, squash-stretch, cascading pours | Linear movement, basic transitions |
| Typography | SF Pro Rounded, generous spacing | Generic sans-serif, tight spacing |
| Whitespace | Generous — board is the hero | Cramped — buttons, ads, banners everywhere |
| Menu style | Glass morphism modal sheets | Full-screen transitions, cluttered |
| Celebrations | Palette-matched confetti, quick, satisfying | Generic confetti, often delayed by ads |
| Ads | Zero interstitials. Premium model. | Ads after every level, mid-game popups |
| Colorblind | First-class: patterns + auto-detection | Absent or paid cosmetic |
| Dark mode | Default signature look | Afterthought or absent |
| Sound | Designed ASMR-quality effects | Generic or annoying |

---

## 8. Competitive Visual Audit — Key Games

### Water Sort Puzzle (IEC Global) — Category Leader

- **Visual style**: Clean minimal 2D. Solid light blue/gradient background. Transparent glass flasks with rounded bottoms.
- **Ball/liquid rendering**: Flat colored liquid layers inside tubes. No 3D effects. Colors are vivid but can be confusing at higher levels.
- **Tube layout**: Single row → two rows as levels increase.
- **Celebrations**: Confetti on level complete. Users specifically praise "confetti flying around" as a feel-good moment.
- **Menu**: Simple. Play button centered. Level number prominent. Settings gear top corner.
- **Dark mode**: Available (added as a later update). Described as providing "a visually immersive experience."
- **Weakness**: Looks like a stock template. Nothing about the visual design is memorable.

### Ball Sort Puzzle (Sergey Dmitriev) — Most Rated Ball Sort

- **Visual style**: 2D balls against a nature landscape background (forest, dusk sky). Muted, atmospheric.
- **Ball rendering**: Standard radial gradient spheres. Well-executed but unremarkable.
- **Tube layout**: Test tubes hanging in the foreground of an outdoor scene. Two rows for complex levels.
- **Celebrations**: "A test tube shoots colored confetti" when a tube is sorted. Per-tube celebration.
- **Seasonal**: Updates include themed ball skins (St. Patrick's Day, spring flowers).
- **Menu**: Standard level map with node-based progression path.
- **Weakness**: Nature background is unique but makes color reading harder in some lighting conditions.

### Color Sort 3D — Hoop Puzzle (Zephyr Mobile)

- **Visual style**: Full 3D environment. Tubes sit on a surface viewed from above at an angle.
- **Ball rendering**: 3D spheres with realistic lighting and reflection.
- **Tube rendering**: Transparent 3D glass cylinders.
- **Pour animation**: 3D liquid pour with physics-like flow.
- **Celebrations**: 3D confetti with depth.
- **User reception**: Praised for visual beauty. "The 3D colors are beautiful and sorting them into the right tubes is so incredibly satisfying."
- **Weakness**: 3D perspective causes confusion about which tube is which. Higher battery drain.

### Nut Sort (Tripledot Studios)

- **Visual style**: Semi-3D. Bolts/pegs on flat surfaces viewed from above. Island scenes as backgrounds.
- **Object rendering**: 3D-rendered nuts/rings stacked on bolts. Vibrant, detailed.
- **Layout**: Grid of bolts rather than tubes. Different spatial paradigm.
- **Progress**: Uniquely designed island scenes unlock as you progress — "vibrant in detail, making you feel like you're embarking on a magical adventure."
- **Accessibility**: Purchasable patterned nut designs for colorblind players.
- **Weakness**: Patterns are behind a paywall, not a free accessibility feature.

### Colorwood Sort

- **Visual style**: Wooden aesthetic. Pegs on a wooden surface. Warm, tactile.
- **Object rendering**: Colored wooden blocks on pegs. Distinct from glass/ball approaches.
- **Feel**: "Combines colorful visuals with tactile feedback, making it both fun and relaxing."
- **Music**: Specifically praised — "the music is a vibe."
- **Weakness**: Overwhelming ads. Players quit despite loving the game.

---

## 9. Key Takeaways & PourSort Visual Strategy

### Do This

1. **Dark-mode-first** with a rich charcoal/navy background — no competitor leads with this
2. **2D premium balls** with radial gradients, specular highlights, and color-tinted shadows — render them beautifully, not just functionally
3. **Frosted glass tubes** using SwiftUI materials — feel native to iOS, modern
4. **Spring-based everything** — all movement feels physical and weighty
5. **Signature pour animation** — the cascading ball arc is the brand's kinetic identity
6. **Generous spacing** — let the game board breathe; don't fill every pixel with UI
7. **Zero ad clutter** — the cleanest screen in the entire genre
8. **Colorblind-first** — auto-detect accessibility settings, patterns built into the design system
9. **ASMR-quality sound design** — soft, satisfying, no music by default
10. **Seasonal subtlety** — accent color shifts, not full reskins

### Don't Do This

1. ❌ Bright gradient backgrounds (every competitor does this)
2. ❌ Nature/landscape backgrounds behind tubes (reduces color readability)
3. ❌ 3D rendering (adds complexity without proportional benefit for our approach)
4. ❌ Cartoon/illustrated UI chrome (looks like every free Unity template)
5. ❌ Cluttered home screen with event banners, shop buttons, currency displays
6. ❌ Star rating per level (adds anxiety to a relaxing game)
7. ❌ Literal world maps for level progression (overdone)
8. ❌ Generic confetti library — build palette-matched particles
9. ❌ Colors that are only distinguishable by hue lightness (dark blue + blue)
10. ❌ Forced celebrations that delay the "Next" button

### The One-Line Visual Brief

> **PourSort should look like it was designed by the people who designed the iOS Weather app — not by the people who built the ad-funded games it competes with.**

---

## Sources

1. App Store: Water Sort Puzzle (IEC Global) — https://apps.apple.com/us/app/water-sort-puzzle
2. App Store: Ball Sort Puzzle (Sergey Dmitriev) — https://apps.apple.com/us/app/ball-sort-color-puzzle-games/id1596200530
3. App Store: Ball Sort Puzzle - Color Game (Guru Smart) — https://apps.apple.com/us/app/ball-sort-puzzle-color-game/id1625097467
4. App Store: Color Sort 3D — Hoop Puzzle — https://apps.apple.com/us/app/color-sort-3d-hoop-puzzle/id6444674771
5. App Store: Nut Sort (Tripledot Studios) — https://apps.apple.com/us/app/nut-sort-color-sorting-game/id6476144780
6. App Store: Colorwood Sort — https://apps.apple.com/us/app/colorwood-sort-puzzle-game/id6475673897
7. App Store: Color Sort Games — https://apps.apple.com/us/app/color-sort-games/id1598498967
8. App Store: Hexa Stack: Color Sort Puzzle — https://apps.apple.com/us/app/hexa-stack-color-sort-puzzle/id6479386856
9. Google Play: Color Water Sort Puzzle Games (TapNation) — https://play.google.com/store/apps/details?id=com.playspare.watersort3d
10. Google Play: Water Sort: Color Tube Puzzle (FlyFox) — https://play.google.com/store/apps/details?id=water.sort.puzzle.color.sort.games
11. Google Play: Water Sort! Color Sort Puzzle — https://play.google.com/store/apps/details?id=water.sort.color.puzzle.offline.games
12. Google Play: Ball Sort Puzzle: Color Master — https://play.google.com/store/apps/details?id=ball.sort.color.water.puzzle.games
13. Google Play: Color Sort 3D - Matching Game — https://play.google.com/store/apps/details?id=games.hypercasual.colorsortpuzzle
14. BubbleShooter.com: Ball Sort Puzzle analysis — https://www.bubbleshooter.com/g/ball-sort-puzzle/
15. BubbleShooter.net: Ball Sort Puzzle analysis — https://www.bubbleshooter.net/game/ball-sort-puzzle/
16. BR Softech: Top 10 Water Sort Puzzle Games 2026 — https://www.brsoftech.com/blog/develop-water-sort-puzzle-game/
17. MWM.ai: Color Water Sort Puzzle 3D analysis — https://mwm.ai/apps/color-water-sort-puzzle-3d/1566301002
18. WaterSort.org — https://watersort.org/
19. Figma Community: Color Sort Water Puzzle Game 2024 — https://www.figma.com/community/file/1350758337776351496
20. PourSort internal research: competitor-analysis.md, animation-ux.md, pain-points.md
