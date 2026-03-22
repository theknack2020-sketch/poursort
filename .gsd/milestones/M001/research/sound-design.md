# Sound Design Research — PourSort (Ball Sort Puzzle)

## Summary

Sound is a critical but often underestimated component of casual puzzle games. For a ball-sorting/pouring game like PourSort, the right audio creates a satisfying feedback loop that reinforces player actions and drives retention. Research shows that 50% of players consider audio quality a crucial factor in their gaming experience, and sound effects can enhance satisfaction and prolong interaction time by ~15%. The recommended approach is a hybrid: use royalty-free samples for core SFX (pour, clink, fanfare) with light procedural variation via AVAudioEngine, and keep ambient music minimal and lo-fi.

---

## 1. What Makes Sorting/Pouring Sounds Satisfying?

### Pour / Liquid Sound Effects
- **ASMR-quality close-mic recordings** are the gold standard for satisfying liquid sounds. Think: the pitch-rising fill of a glass, the initial splash transitioning to a steady stream, the final gurgles as pouring completes.
- **Key layers:** initial splash → steady stream → pitch rise as container fills → final bubble/settle.
- **Pitch modulation is essential:** the pitch of a pour sound should rise as the tube fills up, giving the player an audible sense of progress. This can be done procedurally by adjusting pitch based on fill level.
- **Viscosity matters for feel:** a slightly thickened liquid sound (not water-thin, not syrupy) feels more "game-like" and satisfying. Think somewhere between water and smoothie.

### Ball Clinking / Landing
- Short, crisp impact sounds with a bright attack and quick decay.
- **Material matters:** glass/marble clinks feel premium; plastic thuds feel casual; wood taps feel cozy. For a colorful ball-sort game, glass/marble is the best fit — bright, clear, satisfying.
- **Layered approach:** a subtle "thud" body + a bright "clink" transient on top. Vary pitch slightly per ball color for subliminal differentiation.
- **Stacking variation:** as balls stack, subtle pitch changes (rising) reinforce the visual of the tube filling. The final ball landing in a completed set should feel heavier/more resonant.

### Tube Filling / Completion
- A rising musical phrase or ascending tone sequence as a tube fills (e.g., each ball adds a note going up a scale).
- **Completion sting:** when a tube is fully sorted, a short satisfying chime — a 2-3 note ascending phrase ending on a consonant interval (major third, perfect fifth). Think Candy Crush's match sounds but more subtle.
- **"Lock" sound:** a soft mechanical click or snap when a tube is sealed/completed, providing tactile feedback.

### Level Complete Fanfare
- Short (1-3 seconds), bright, celebratory.
- **Musical elements:** ascending arpeggios, sparkle/shimmer textures, a resolved chord progression (e.g., V → I cadence).
- **Layered approach:** combine a musical stinger with particle/sparkle SFX. Avoid being obnoxious — casual puzzle players want satisfaction, not a marching band.
- **Progression:** consider escalating the fanfare intensity for higher levels or perfect completions (no undo used).

### Menu / UI Sounds
- Light, non-intrusive taps and clicks for navigation.
- Soft pops for button presses, gentle whooshes for screen transitions.
- Distinct but subtle sounds for: button tap, back/close, toggle, slider, popup appear/dismiss.
- Avoid harsh clicks or overly "digital" sounds — organic, recorded source sounds feel warmer.
- Professional casual game SFX libraries typically include 15+ categories covering all UI interactions.

---

## 2. Ambient Background Music

### Style Recommendations
- **Lo-fi / chill:** gentle piano, soft synth pads, muted percussion. Lo-fi hip-hop aesthetics work well for the relaxation-oriented puzzle demographic.
- **Nature ambience:** soft rain, distant birds, gentle wind as a layer under (or instead of) melodic music. Creates a calming atmosphere without fatiguing the ear.
- **Minimalist:** sparse arrangements that can loop endlessly without becoming annoying. Short notes preferred over long sustains. Avoid heavy percussion, avoid prominent bass lines (phone speakers can't reproduce them well anyway).

### Composition Guidelines (from professional game audio designers)
- Very light and sparse arrangements that tolerate endless repeating.
- Short notes preferred over long sustained notes.
- Avoid percussion except for subtle shakers or cymbal rolls.
- Keep bass minimal — most players use phone speakers.
- Don't compete with SFX frequencies — if SFX use bright chimes and clinks, keep music in the mid-low range.
- Music should sit well below SFX in the mix hierarchy. Compose with SFX playing on top to verify.
- Consider adaptive layers: music could subtly intensify as the player nears completion or faces difficulty.

### Practical Approach for PourSort
- **2-3 looping ambient tracks** (each 60-90 seconds) that crossfade between levels or themes.
- **Nature ambient layer** (rain, garden, café) as an optional alternative the player can toggle.
- Use royalty-free lo-fi loops from sources like Uppbeat, Pixabay, or commission from a freelancer.

---

## 3. Sound & Player Retention

### Key Research Findings

| Finding | Source |
|---------|--------|
| 50% of players say audio quality is a crucial factor in their gaming experience | Newzoo report (cited by MoldStud) |
| Sound effects enhance satisfaction and prolong interaction time by ~15% | MoldStud retention study |
| 80% of players report improved enjoyment with high-quality animations and synchronized audio | MoldStud retention study |
| Soundtracks and visuals contributing to story can improve retention by ~15% | MoldStud retention study |
| Players who play with sound on play more frequently and for longer sessions | TapResearch survey |
| Players who rarely have sound on are 58% more likely to have never made an in-game purchase | TapResearch survey |
| Sound design improves perceived competence, immersion, flow, and attention retention | ResearchGate study (Cao et al., 2023) |
| Only ~8% of mobile gamers surveyed play with game sound on (most play while doing other activities) | TapResearch survey |

### Implications for PourSort
- **Sound is a retention multiplier** for players who use it — and those players are more engaged and more likely to spend money.
- **But most casual players play with sound off.** This means: (a) the game must be excellent without sound, (b) sound should be an additive delight, not a dependency, (c) first-session audio impressions matter — players who hear great sound early may keep it on.
- **Haptics can supplement sound** for players with sound off — consider pairing key SFX triggers with haptic feedback (UIImpactFeedbackGenerator).
- **Dopamine loop:** the satisfying sound of completing a tube or level triggers dopamine release, reinforcing the behavior loop. Auditory reward cues are one of the most powerful retention tools in casual games.

---

## 4. Procedural Generation vs. Royalty-Free Assets

### Procedural Audio (Generated at Runtime)

**Pros:**
- Infinite variation — no sound repetition fatigue.
- Tiny memory footprint (no large WAV files).
- Dynamic: sounds can react to game state (fill level, speed, ball count).
- Pour sounds are excellent candidates — pitch/filter can track fill level.

**Cons:**
- More complex to implement; requires DSP knowledge.
- Hard to match the organic quality of well-recorded samples.
- CPU overhead on mobile (though minimal for simple synthesis).
- Limited creative palette without significant tooling investment.

**Best suited for:** pour/liquid sounds (pitch-modulated noise), ball-on-ball clink variations (pitch-shifted samples), subtle UI hover/tap variations.

### Royalty-Free Sample Assets

**Pros:**
- Professional quality out of the box.
- Fast to implement — just play the file.
- Rich, organic, complex sounds that synthesis can't easily match.
- Many game-ready packs available (BOOM Library, Epic Stock Media, WowSound, Pixabay, Uppbeat).

**Cons:**
- File size adds to app bundle (mitigated by short SFX being tiny — typically <100KB each).
- Repetition if the same sample plays identically every time.
- Licensing terms vary — verify "royalty-free for commercial use" status.

**Best suited for:** level complete fanfares, menu/UI sounds, ball clink base samples, ambient music loops.

### Recommended Hybrid Approach for PourSort
1. **Core SFX from royalty-free packs:** ball clinks (3-5 variations), tube complete chime, level fanfare, UI taps/clicks. Total: ~20-30 small files, <2MB.
2. **Procedural variation layer:** randomize pitch (±5-10%), volume (±10%), and playback position slightly on each trigger to prevent repetition.
3. **Pour sound: semi-procedural.** Use a short recorded water/liquid loop as source, then modulate pitch and filter cutoff based on fill level using AVAudioEngine. This gives organic quality with dynamic responsiveness.
4. **Background music: pre-recorded loops.** Lo-fi ambient tracks, crossfaded. 2-3 tracks in AAC format.

---

## 5. AVAudioEngine vs. AVAudioPlayer

### AVAudioPlayer
- **Simple API:** load file → play. Volume, rate, looping, metering built in.
- **Good for:** background music, simple one-shot SFX that don't need effects or mixing.
- **Limitations:** can't play from buffers, no real-time effects (pitch/reverb/EQ), no audio graph, no latency guarantees.
- **Overhead:** each instance wraps the AudioQueue C API. Playing many simultaneous sounds requires multiple AVAudioPlayer instances.

### AVAudioEngine
- **Modern audio graph API:** connect nodes (players → effects → mixer → output).
- **Real-time control:** pitch shifting, time stretching, reverb, EQ, custom effects via node chain.
- **Buffer-based playback:** preload SFX into AVAudioPCMBuffer for low-latency triggered playback — critical for game feel.
- **Multiple simultaneous sounds:** use a pool of AVAudioPlayerNode instances attached to the engine. A pool of ~20 nodes is typical for casual games.
- **3D audio / spatialization** if needed in future.
- **Limitations:** more complex setup, no built-in metering like AVAudioPlayer, and overlapping rapid-fire playback of the same sound requires a node pool (one node per concurrent instance).

### Can They Coexist?
Yes. Apple Developer Forums confirm they are **not mutually exclusive** — AVAudioPlayer wraps AudioQueue while AVAudioEngine wraps Audio Units. They can run simultaneously without conflict.

### Recommendation for PourSort

**Use AVAudioEngine as the primary audio system**, with this architecture:

```
┌─────────────────────────────────────────────────┐
│                  AVAudioEngine                   │
│                                                  │
│  ┌──────────────┐   ┌───────────────────────┐   │
│  │ SFX Player   │──▶│ Pitch/Speed Control   │──┐│
│  │ Pool (10-20) │   │ (AVAudioUnitTimePitch)│  ││
│  └──────────────┘   └───────────────────────┘  ││
│                                                 ▼│
│  ┌──────────────┐   ┌───────────────────────┐ ┌─┴──────────┐
│  │ Music Player │──▶│ Volume/EQ             │─▶│Main Mixer  │──▶ Output
│  │ Node         │   │                       │ │ Node        │
│  └──────────────┘   └───────────────────────┘ └────────────┘
│                                                  │
│  ┌──────────────┐                                │
│  │ Pour Loop    │──▶ Pitch/Filter (dynamic) ────┘│
│  │ Player       │   (tracks fill level)          │
│  └──────────────┘                                │
└─────────────────────────────────────────────────┘
```

**Why AVAudioEngine over AVAudioPlayer:**
- Pour sound needs real-time pitch modulation (pitch rises with fill level) — only possible with AVAudioEngine.
- Ball clink sounds need randomized pitch per trigger — AVAudioUnitTimePitch does this.
- Preloaded buffers give lower latency than file-based AVAudioPlayer.
- Single mixer node controls master volume for all SFX vs. music separately.
- Future-proof: Apple is investing in AVAudioEngine, and older C APIs (AUGraph, AudioToolbox) are deprecated in favor of it.

**Implementation notes:**
- Use CAF format (Linear PCM, 16-bit) for SFX — lowest CPU decode overhead.
- Use AAC/M4A for background music — good compression, hardware-decoded.
- Preload all SFX buffers at scene init, release on scene teardown.
- Pool 10-20 AVAudioPlayerNode instances for SFX; rotate through them.
- Use GameSoundEngine (open-source Swift library built on AVAudioEngine) as reference architecture or starting point.

---

## 6. Sound Asset List for PourSort

| Category | Sound | Count | Source Strategy |
|----------|-------|-------|-----------------|
| Pour/liquid | Water pour loop (short, loopable) | 2-3 | Royalty-free + pitch modulation |
| Pour/liquid | Pour start splash | 1-2 | Royalty-free |
| Pour/liquid | Pour end bubble/settle | 1-2 | Royalty-free |
| Ball | Ball clink/landing (glass/marble) | 4-5 | Royalty-free + pitch randomization |
| Ball | Ball slide/roll (tube interior) | 2-3 | Royalty-free |
| Tube | Tube complete chime | 2 | Royalty-free or custom |
| Tube | Tube lock/seal click | 1-2 | Royalty-free |
| Level | Level complete fanfare (short) | 2-3 | Royalty-free or custom |
| Level | Star/rating reveal | 1-2 | Royalty-free |
| UI | Button tap | 2-3 | Royalty-free |
| UI | Screen transition whoosh | 1-2 | Royalty-free |
| UI | Toggle/switch | 1 | Royalty-free |
| UI | Popup appear/dismiss | 2 | Royalty-free |
| UI | Error/invalid move | 1-2 | Royalty-free |
| Ambient | Lo-fi background loop | 2-3 | Royalty-free |
| Ambient | Nature ambient (rain/garden) | 1-2 | Royalty-free |

**Estimated total:** ~30-40 sound files, <5MB in compressed format.

---

## 7. Recommended Sources

### Royalty-Free SFX Libraries
- **Pixabay** (pixabay.com/sound-effects) — free, no attribution required
- **Uppbeat** (uppbeat.io/sfx) — free tier available, good liquid/pour sounds
- **BOOM Library - Casual UI** — professional game SFX pack, 15 categories
- **Epic Stock Media - Puzzle Game** — 550+ game-ready SFX, $49
- **WowSound - Game UI & Puzzle Pack** — 900+ SFX + music stingers

### AI-Generated SFX
- **ElevenLabs Sound Effects** — text-to-SFX generation, royalty-free output
- **SFX Engine** — AI sound effect generator with puzzle/casual presets

### Open Source / Reference
- **GameSoundEngine** (github.com/tkier/GameSoundEngine) — Swift AVAudioEngine wrapper designed for iOS games. Handles player pooling, background music, audio session management.

---

## 8. Key Takeaways

1. **Pour sound is the hero sound** — invest the most effort here. Use a recorded liquid loop with AVAudioEngine pitch modulation tracking fill level.
2. **Ball clinks need variation** — 4-5 base samples with randomized pitch/volume to prevent repetition fatigue.
3. **Level complete fanfare = dopamine trigger** — short, bright, satisfying. This drives the retention loop.
4. **Music should be invisible** — lo-fi ambient that doesn't compete with SFX. Sparse, loopable, forgettable-in-a-good-way.
5. **AVAudioEngine is the right choice** — real-time pitch control for pour sounds, buffer-based low-latency SFX, single mixer graph.
6. **Hybrid approach** — royalty-free samples + procedural variation (pitch/volume randomization + pour pitch tracking).
7. **Pair sound with haptics** — cover the ~92% of casual players who play with sound off.
8. **Total investment: small.** ~30-40 sound files, <5MB, achievable with free sources. The engineering effort is in the AVAudioEngine setup, not the assets.
