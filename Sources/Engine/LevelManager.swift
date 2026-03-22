import Foundation

@MainActor
final class LevelManager {
    static let shared = LevelManager()

    private let defaults = UserDefaults.standard

    var currentLevelNumber: Int {
        get { max(1, defaults.integer(forKey: "ps_current_level")) }
        set { defaults.set(newValue, forKey: "ps_current_level") }
    }

    var highestLevel: Int {
        get { max(1, defaults.integer(forKey: "ps_highest_level")) }
        set { defaults.set(newValue, forKey: "ps_highest_level") }
    }

    private init() {
        if defaults.integer(forKey: "ps_current_level") == 0 {
            currentLevelNumber = 1
            highestLevel = 1
        }
    }

    func configForLevel(_ level: Int) -> LevelConfig {
        // Progressive difficulty across 5 worlds (100 levels each)
        let world = (level - 1) / 100  // 0-4
        let posInWorld = (level - 1) % 100

        let colorCount: Int
        let emptyTubes: Int

        switch world {
        case 0: // World 1: Tutorial (3-4 colors)
            colorCount = posInWorld < 50 ? 3 : 4
            emptyTubes = 2
        case 1: // World 2: Easy (4-5 colors)
            colorCount = posInWorld < 50 ? 4 : 5
            emptyTubes = 2
        case 2: // World 3: Medium (5-7 colors)
            colorCount = 5 + min(posInWorld / 34, 2)
            emptyTubes = posInWorld < 70 ? 2 : 1
        case 3: // World 4: Hard (7-9 colors)
            colorCount = 7 + min(posInWorld / 50, 2)
            emptyTubes = posInWorld < 50 ? 2 : 1
        default: // World 5+: Expert (8-10 colors)
            colorCount = 8 + min(posInWorld / 50, 2)
            emptyTubes = 1
        }

        return LevelConfig(
            levelNumber: level,
            colorCount: min(colorCount, 10),
            tubeCount: min(colorCount, 10),
            emptyTubes: emptyTubes,
            capacity: 4,
            seed: UInt64(level) * 6364136223846793005 + 1442695040888963407
        )
    }

    func completeLevel(_ level: Int) {
        if level >= highestLevel {
            highestLevel = level + 1
        }
        currentLevelNumber = level + 1
    }

    // World info
    func worldName(for level: Int) -> String {
        let world = (level - 1) / 100
        switch world {
        case 0: return "Tutorial"
        case 1: return "Easy"
        case 2: return "Medium"
        case 3: return "Hard"
        default: return "Expert"
        }
    }

    func worldNumber(for level: Int) -> Int {
        ((level - 1) / 100) + 1
    }
}
