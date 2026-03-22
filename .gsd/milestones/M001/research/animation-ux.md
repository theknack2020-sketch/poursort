# Animation & UX Research — PourSort

Research covering ball movement animations, pour/flow effects, tube rendering, color palette design, celebration effects, particle systems, haptic feedback, and what makes sorting feel satisfying.

---

## 1. Ball Movement Animations

### Spring Animations (Primary)

Springs should be the default animation type for all ball movement. Apple uses springs as the default animation in SwiftUI since iOS 17 — they feel natural because they mimic real physics with continuous position and velocity.

**Recommended spring configurations for ball sort:**

| Action | Animation | Parameters | Rationale |
|--------|-----------|------------|-----------|
| Ball lift (tap source tube) | `.spring(duration: 0.25, bounce: 0.15)` | Fast, slight bounce | Snappy pickup feels responsive |
| Ball hover/float above tube | `.spring(duration: 0.3, bounce: 0.0)` | Smooth, no bounce | Ball should float cleanly above selected tube |
| Ball arc to destination | `.spring(duration: 0.4, bounce: 0.2)` | Medium speed, gentle bounce | Arc motion needs to feel weighty but not sluggish |
| Ball drop into tube | `.spring(duration: 0.35, bounce: 0.3)` | Quick with visible bounce | Landing bounce sells the physical weight |
| Ball settle in tube | `.interpolatingSpring(duration: 0.2, bounce: 0.0)` | Critically damped | No oscillation — ball locks into place |
| Invalid move shake | `.spring(duration: 0.3, bounce: 0.5)` | High bounce, short | Horizontal shake that clearly reads as "nope" |

**Key API patterns:**

```swift
// Explicit animation — use for tap-triggered ball moves
withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
    ballPosition = destinationPosition
}

// Implicit animation — use for continuous state-driven changes
Circle()
    .offset(y: isLifted ? -60 : 0)
    .animation(.spring(duration: 0.25, bounce: 0.15), value: isLifted)
```

### Keyframe Animations (Pour Sequence)

The ball pour is a multi-phase animation: lift → arc → drop → settle. `KeyframeAnimator` (iOS 17+) is ideal for choreographing this sequence with different timing per phase.

```swift
.keyframeAnimator(initialValue: PourValues(), trigger: pourTrigger) { content, value in
    content
        .offset(x: value.xOffset, y: value.yOffset)
        .scaleEffect(value.scale)
} keyframes: { _ in
    KeyframeTrack(\.yOffset) {
        // Phase 1: Lift ball above tube
        SpringKeyframe(-80, duration: 0.2, spring: .snappy)
        // Phase 2: Hold at top briefly
        LinearKeyframe(-80, duration: 0.1)
        // Phase 3: Arc to destination (horizontal)
        SpringKeyframe(-80, duration: 0.3, spring: .smooth)
        // Phase 4: Drop into tube
        SpringKeyframe(targetY, duration: 0.35, spring: .bouncy)
    }
    KeyframeTrack(\.xOffset) {
        LinearKeyframe(0, duration: 0.2)
        LinearKeyframe(0, duration: 0.1)
        SpringKeyframe(destinationX, duration: 0.3, spring: .smooth)
        LinearKeyframe(destinationX, duration: 0.35)
    }
    KeyframeTrack(\.scale) {
        LinearKeyframe(1.0, duration: 0.2)
        SpringKeyframe(1.15, duration: 0.1, spring: .bouncy) // Slight scale up when lifted
        LinearKeyframe(1.15, duration: 0.3)
        SpringKeyframe(1.0, duration: 0.35, spring: .smooth) // Return to normal
    }
}
```

### Phase Animations (Idle/Ambient)

Use `phaseAnimator` for subtle ambient effects — a gentle pulse on the selected tube, idle ball shimmer, etc.

```swift
.phaseAnimator([false, true], trigger: isSelected) { content, phase in
    content
        .scaleEffect(phase ? 1.03 : 1.0)
        .brightness(phase ? 0.05 : 0)
} animation: { phase in
    phase ? .easeInOut(duration: 0.6) : .easeInOut(duration: 0.6)
}
```

### Timing Curves (Secondary)

Use easing curves for non-interactive, automatic animations only:
- `.easeOut` — Ball shadow opacity change as ball rises
- `.easeInOut` — Background color transitions, UI panel slides
- `.linear` — Particle system rotation, confetti spin

Springs should handle all user-triggered movement. Timing curves are for ambient/decorative motion.

---

## 2. Pour / Flow Effects

### Visual Pour Arc

The ball should follow a parabolic arc from source to destination, not a straight line. This reads as a "pour" rather than a teleport.

**Arc path approach:**

```swift
struct ArcPath: Shape {
    var from: CGPoint
    var to: CGPoint
    var arcHeight: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = (from.x + to.x) / 2
        let controlPoint = CGPoint(x: midX, y: min(from.y, to.y) - arcHeight)
        path.move(to: from)
        path.addQuadCurve(to: to, control: controlPoint)
        return path
    }
}
```

**Animating along the path** — rather than separate x/y keyframes, use a `0...1` progress value animated with a spring, then interpolate position along the quadratic Bézier.

### Multi-Ball Pour (Consecutive Balls)

When multiple balls of the same color pour at once (stacked same-color balls), stagger the animations:
- Delay each subsequent ball by ~0.08s
- Each ball follows the same arc but with cascading timing
- Creates a satisfying "flow" visual rather than parallel movement

### Squash & Stretch

Sell the weight of the balls:
- **Stretch vertically** during fast downward movement (scaleX: 0.9, scaleY: 1.15)
- **Squash on landing** (scaleX: 1.15, scaleY: 0.85) for one frame, then spring back
- Use `KeyframeTrack` on scaleX/scaleY for this — timing must be tight (~0.1s squash)

### Tube Tilt Animation (Optional Polish)

When a ball leaves a tube, the source tube could do a subtle tilt in the pour direction (1-2° rotation), then spring back. Same for the receiving tube — a micro "catch" wobble.

---

## 3. Tube Container Rendering

### Glass Tube Effect

Tubes should read as transparent glass containers. Pure SwiftUI approach:

```swift
struct TubeView: View {
    let balls: [BallColor]
    let capacity: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tube body — glass effect
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial) // Glass-like blur
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.6), .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            
            // Ball stack
            VStack(spacing: 4) {
                ForEach(balls) { ball in
                    BallView(color: ball.color)
                }
            }
            .padding(.bottom, 8)
        }
        .frame(width: 60, height: CGFloat(capacity) * 54 + 20)
    }
}
```

### Ball Rendering

Each ball should have dimensionality — not flat circles:

```swift
struct BallView: View {
    let color: Color
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color.opacity(0.9), color, color.adjusted(brightness: -0.3)],
                    center: .init(x: 0.35, y: 0.35), // Off-center highlight
                    startRadius: 2,
                    endRadius: 22
                )
            )
            .overlay(
                // Specular highlight
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.7), .clear],
                            center: .init(x: 0.3, y: 0.3),
                            startRadius: 0,
                            endRadius: 10
                        )
                    )
                    .scaleEffect(0.5)
                    .offset(x: -5, y: -5)
            )
            .shadow(color: color.opacity(0.4), radius: 3, y: 2)
            .frame(width: 44, height: 44)
    }
}
```

### Layout Strategy

- Use `LazyHGrid` or manual `HStack` for tube positioning
- Tubes should be evenly spaced with enough tap target area (44pt minimum)
- For 7+ tubes, use two rows or allow horizontal scroll
- Tube bottom should be rounded (closed), top should be open (no cap)
- Consider a subtle inner shadow at tube bottom for depth

---

## 4. Color Palette Design

### Requirements

- **Minimum 10 distinct colors** for advanced levels
- **WCAG AA contrast** between all colors (4.5:1 against each other where adjacent)
- **Colorblind-safe** — distinguishable in protanopia, deuteranopia, tritanopia
- **Vibrant but not fatiguing** — players stare at these for hours

### Recommended Base Palette (10 Colors)

| Name | Hex | RGB | Notes |
|------|-----|-----|-------|
| Ruby | `#E63946` | 230, 57, 70 | Warm red, distinct from orange |
| Tangerine | `#F4A261` | 244, 162, 97 | Warm orange, lighter than red |
| Sunflower | `#F2CC0C` | 242, 204, 12 | Bright yellow, high luminance |
| Emerald | `#2A9D8F` | 42, 157, 143 | Teal-green, avoids red-green confusion |
| Ocean | `#264653` | 38, 70, 83 | Deep blue-teal, dark anchor |
| Sky | `#4EA8DE` | 78, 168, 222 | Light blue, distinct from ocean |
| Violet | `#7B2CBF` | 123, 44, 191 | Rich purple |
| Rose | `#FF6B9D` | 255, 107, 157 | Pink, distinct from ruby by saturation |
| Mint | `#80ED99` | 128, 237, 153 | Light green, high luminance |
| Slate | `#6C757D` | 108, 117, 125 | Neutral gray, luminance anchor |

### Colorblind Mode

Overlay distinct **shapes/patterns** on each ball when colorblind mode is active:
- Stripes, dots, crosses, diamonds, stars, rings, chevrons, waves, grid, solid
- Each shape maps to a color 1:1
- Toggle in settings, detect system accessibility preferences with `accessibilityDifferentiateWithoutColor`

```swift
@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
```

### Dark Mode Considerations

- Tube glass material auto-adapts with `.ultraThinMaterial`
- Ball colors need slightly higher saturation in dark mode
- Ball specular highlight becomes more prominent against dark backgrounds
- Background should be dark but not pure black — use `Color(hue: 0.6, saturation: 0.15, brightness: 0.12)`

---

## 5. Confetti / Celebration on Level Complete

### Library Options

**ConfettiSwiftUI** (recommended for v1):
- Pure SwiftUI, no dependencies — matches project philosophy
- MIT license, mature (3+ years)
- Supports shapes (circle, triangle, square, slimRectangle, roundedCross), emojis, SF Symbols, custom text
- Configurable: particle count, radius, colors, rain height, repetitions, confetti size
- Trigger via simple integer state change

```swift
import ConfettiSwiftUI

@State private var confettiTrigger = 0

// On level complete:
confettiTrigger += 1

// In view:
.confettiCannon(
    trigger: $confettiTrigger,
    num: 40,
    confettis: [.shape(.circle), .shape(.triangle), .shape(.slimRectangle)],
    colors: [.ruby, .emerald, .sky, .sunflower, .violet], // Match game palette
    confettiSize: 12,
    radius: 350,
    rainHeight: 600
)
```

**However — no third-party dependencies is a project constraint.** Build a lightweight custom confetti instead:

### Custom Confetti (Recommended)

Use SwiftUI `Canvas` + `TimelineView` for performant particle rendering:

```swift
struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    let isActive: Bool
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for particle in particles {
                    let elapsed = time - particle.startTime
                    guard elapsed < particle.lifetime else { continue }
                    
                    let progress = elapsed / particle.lifetime
                    let x = particle.startX + particle.velocityX * elapsed
                    let y = particle.startY + particle.velocityY * elapsed + 0.5 * 800 * elapsed * elapsed // gravity
                    let opacity = 1.0 - progress
                    let rotation = particle.spin * elapsed
                    
                    context.opacity = opacity
                    context.translateBy(x: x, y: y)
                    context.rotate(by: .degrees(rotation))
                    context.fill(
                        particle.shape,
                        with: .color(particle.color)
                    )
                    context.rotate(by: .degrees(-rotation))
                    context.translateBy(x: -x, y: -y)
                }
            }
        }
        .allowsHitTesting(false)
        .onChange(of: isActive) { _, active in
            if active { spawnParticles() }
        }
    }
}
```

### Celebration Sequence (Level Complete)

1. **T+0ms**: All balls flash white briefly (0.15s)
2. **T+100ms**: Confetti burst from center-top, spreading outward
3. **T+100ms**: Haptic `.success` feedback
4. **T+200ms**: Completed tubes do a subtle bounce animation (staggered)
5. **T+300ms**: "Level Complete" text scales in with `.spring(bounce: 0.4)`
6. **T+500ms**: Star rating / score display fades in
7. **T+2000ms**: Confetti fades out with `.easeOut`
8. **T+2500ms**: "Next Level" button appears

For **chapter completion** (every 20-50 levels), amplify:
- Double particle count
- Add screen-edge sparkle effects
- Longer confetti duration
- More dramatic text animation

---

## 6. Particle Effects

### When to Use Particles

| Effect | Trigger | Particle Count | Duration |
|--------|---------|---------------|----------|
| Ball lands in tube | Each successful pour | 4-6 tiny particles | 0.3s |
| Tube completed (single color) | Tube full with one color | 12-16 particles | 0.5s |
| Level complete | Win detection | 40-60 confetti | 2.0s |
| Streak bonus | 3+ correct moves | 8-10 sparkles | 0.4s |
| Undo | Undo action | 3-4 smoke puffs | 0.3s |

### Canvas-Based Particle System

`Canvas` is the right tool here — it avoids creating hundreds of SwiftUI views:

```swift
struct ParticleSystem: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x, y: CGFloat
        var velocityX, velocityY: CGFloat
        var color: Color
        var size: CGFloat
        var lifetime: TimeInterval
        var startTime: TimeInterval
        var rotation: Double
        var spin: Double
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                for particle in particles {
                    let elapsed = now - particle.startTime
                    guard elapsed < particle.lifetime else { continue }
                    
                    let progress = elapsed / particle.lifetime
                    let gravity: CGFloat = 300
                    let x = particle.x + particle.velocityX * elapsed
                    let y = particle.y + particle.velocityY * elapsed + 0.5 * gravity * elapsed * elapsed
                    let scale = 1.0 - progress * 0.5
                    let opacity = 1.0 - pow(progress, 2)
                    
                    var ctx = context
                    ctx.opacity = opacity
                    ctx.translateBy(x: x, y: y)
                    ctx.rotate(by: .degrees(particle.rotation + particle.spin * elapsed))
                    ctx.scaleBy(x: scale, y: scale)
                    ctx.fill(
                        Circle().path(in: CGRect(x: -particle.size/2, y: -particle.size/2, 
                                                  width: particle.size, height: particle.size)),
                        with: .color(particle.color)
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    func emit(at point: CGPoint, count: Int, colors: [Color]) {
        let now = Date().timeIntervalSinceReferenceDate
        let newParticles = (0..<count).map { _ in
            let angle = Double.random(in: 0...(2 * .pi))
            let speed = CGFloat.random(in: 50...200)
            return Particle(
                x: point.x, y: point.y,
                velocityX: cos(angle) * speed,
                velocityY: sin(angle) * speed - 150, // upward bias
                color: colors.randomElement()!,
                size: CGFloat.random(in: 3...8),
                lifetime: Double.random(in: 0.4...1.0),
                startTime: now,
                rotation: Double.random(in: 0...360),
                spin: Double.random(in: -360...360)
            )
        }
        particles.append(contentsOf: newParticles)
        
        // Cleanup old particles periodically
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            particles.removeAll { now - $0.startTime > $0.lifetime }
        }
    }
}
```

### Performance Considerations

- **Canvas** renders all particles in a single draw call — far more efficient than N separate Circle views
- Keep particle count under 100 simultaneously for smooth 60fps on older devices (iPhone 12 era)
- Remove expired particles promptly to avoid accumulation
- Use `.allowsHitTesting(false)` on particle layers to avoid blocking touch
- `TimelineView(.animation)` syncs with display refresh rate

---

## 7. Haptic Feedback Patterns

### API: `sensoryFeedback` (iOS 17+)

This is the modern API — no need for UIKit's `UIImpactFeedbackGenerator`.

```swift
.sensoryFeedback(.impact(weight: .medium), trigger: pourTrigger)
```

### Haptic Map for Game Actions

| Action | Feedback Type | Rationale |
|--------|--------------|-----------|
| Tap tube (select) | `.selection` | Light click, confirms selection |
| Ball lifts from tube | `.impact(weight: .light)` | Feels like picking something up |
| Ball lands in tube | `.impact(weight: .medium)` | Satisfying "thunk" on landing |
| Invalid move attempt | `.warning` | Distinct from positive feedback |
| Tube completed (all same color) | `.success` | Positive confirmation |
| Level complete | `.success` + custom pattern | Strongest positive signal |
| Undo | `.selection` | Neutral, informational |
| Restart level | `.impact(weight: .heavy, intensity: 0.5)` | Reset feel, moderate intensity |
| Multi-ball pour | Staggered `.impact(weight: .light)` per ball | Rapid light taps = flow sensation |
| Streak (3+ correct) | `.increase` | Building momentum |

### Implementation Pattern

```swift
struct GameView: View {
    @State private var pourCount = 0
    @State private var completionCount = 0
    
    var body: some View {
        TubeGridView()
            // Pour feedback
            .sensoryFeedback(.impact(weight: .medium), trigger: pourCount)
            // Level complete feedback
            .sensoryFeedback(.success, trigger: completionCount)
            // Dynamic feedback
            .sensoryFeedback(trigger: gameEvent) { oldValue, newValue in
                switch newValue {
                case .invalidMove: return .warning
                case .tubeComplete: return .success
                case .ballSelect: return .selection
                default: return nil
                }
            }
    }
}
```

### Haptic Discipline

- **Don't over-haptic.** Every tap shouldn't buzz. Reserve haptics for meaningful state changes.
- **Match intensity to significance.** Selection = light, pour = medium, level complete = heavy.
- **Respect system settings.** `sensoryFeedback` automatically respects the user's haptic preferences — no need to check manually.
- **Stagger multi-ball haptics.** Rapid-fire identical haptics merge into noise. Space them ~80ms apart.

---

## 8. Making Sorting Feel Satisfying

### The Psychology of Satisfaction

Ball sort games succeed by creating a **tight feedback loop**: action → visual reward → anticipation → next action. Key principles from successful games:

1. **Immediate visual response** — Ball begins moving within one frame of tap. Zero perceived latency.
2. **Weight and physicality** — Springs, squash & stretch, and haptics sell the illusion that balls are real objects.
3. **Progressive reward escalation** — Each correct move feels good. A completed tube feels great. A completed level feels amazing.
4. **Audio-visual-haptic sync** — The ball's landing sound, the visual bounce, and the haptic thud must arrive simultaneously.
5. **Anticipation gaps** — Brief pauses between the ball landing and the tube-complete animation build anticipation.

### Satisfying Micro-Moments

**Ball landing in correct position:**
- Ball bounces on landing (spring with bounce: 0.3)
- 4-6 tiny color-matched particles spray on impact
- Subtle haptic thud
- Balls below compress slightly (squash) then recover

**Tube completion (all same color):**
- 200ms delay after last ball settles (let the player register it)
- All balls in tube flash/glow (brightness +0.15, scale to 1.05)
- Sparkle particles emit from tube
- Tube border shifts to a completed state (gold outline or checkmark)
- `.success` haptic

**Chain moves (quick successive correct moves):**
- Streak counter appears (subtle, corner)
- Haptic escalates from `.impact(weight: .light)` → `.medium` → `.heavy`
- Background subtly pulses brighter with each correct move
- Particle effects increase in intensity

**Level complete:**
- See celebration sequence (Section 5)
- The transition from "game" to "result" should feel earned, not abrupt

### Anti-Patterns to Avoid

- **Sluggish animations** — Ball movement over 0.5s total feels laggy in a puzzle game. Keep the full pour arc under 0.4s.
- **Identical timing** — Every move at exactly the same speed feels robotic. Add ±5% timing variation.
- **Animation blocking input** — Players should be able to tap the next tube during the current animation. Queue the move.
- **Over-celebrating** — If confetti plays on every 3-tube level, it means nothing by level 10. Save the big celebrations for milestones.
- **No feedback on invalid moves** — Silently failing is worse than showing an error. Shake the tube, flash red, play a haptic warning.

### Sound Design Notes (for future reference)

- Ball lift: soft "pop" (high pitch)
- Ball land: satisfying "thunk" or "plop" (depends on theme — glass = clink, wooden = thunk)
- Invalid move: short buzzer or wooden knock
- Tube complete: rising chime
- Level complete: celebratory jingle (2-3 notes ascending)
- Background: ambient minimal music, not distracting — players should be able to play in silence

### Animation Performance Budget

Target: **60fps on iPhone 12 (A14)** — the oldest iOS 17 device.

| Layer | Max simultaneous elements |
|-------|--------------------------|
| Ball views (Circle + gradient) | 28 (7 tubes × 4 balls) |
| Particle system (Canvas) | 100 particles |
| Confetti (Canvas, celebration only) | 60 particles |
| Spring animations in flight | 8 concurrent |
| Ambient animations (pulse, shimmer) | 4 concurrent |

Profile with Instruments (Time Profiler + Core Animation FPS) on a real device, not simulator.

---

## 9. Implementation Priority

For MVP, implement in this order:

1. **Ball spring movement** — Lift, arc, drop with spring animations
2. **Tube rendering** — Glass effect, ball gradients, proper layout
3. **Haptic feedback** — Selection, pour, invalid, complete
4. **Landing particles** — Small burst on each pour (Canvas)
5. **Tube completion glow** — Visual confirmation of single-color tube
6. **Level complete celebration** — Confetti + text + haptics
7. **Squash & stretch** — Polish on ball movement
8. **Multi-ball pour stagger** — Consecutive same-color pour flow
9. **Ambient effects** — Selected tube pulse, idle shimmer
10. **Streak system** — Escalating feedback for consecutive correct moves

Items 1-6 are essential for a satisfying v1. Items 7-10 are polish that can ship in v1.1 if time is tight.

---

## Sources

- Apple WWDC23: "Animate with springs" — spring as default, duration/bounce parameterization, Spring model type
- Apple Developer Documentation: `Animation.spring`, `KeyframeAnimator`, `PhaseAnimator`, `SensoryFeedback`, `Canvas`
- GetStream/swiftui-spring-animations (GitHub) — comprehensive spring parameter reference
- ConfettiSwiftUI (simibac/ConfettiSwiftUI, GitHub) — confetti animation library API reference
- Ball Sort Puzzle competitive analysis — UX patterns across top App Store/Play Store titles
- Apple HIG: Accessibility, Color and contrast guidelines
