import Foundation

@MainActor
final class DailyChallengeManager {
    static let shared = DailyChallengeManager()

    private let defaults = UserDefaults.standard

    /// Today's date string (UTC) — all players get same puzzle
    var todayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: Date())
    }

    /// Seed derived from today's date
    var todaySeed: UInt64 {
        let key = todayKey
        var hash: UInt64 = 5381
        for char in key.utf8 {
            hash = hash &* 33 &+ UInt64(char)
        }
        return hash
    }

    /// Generate today's challenge config
    var todayConfig: LevelConfig {
        // Daily challenges: moderate difficulty (5-7 colors)
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let colorCount = 5 + (dayOfYear % 3) // 5, 6, or 7 colors

        return LevelConfig(
            levelNumber: 0, // 0 = daily challenge
            colorCount: colorCount,
            tubeCount: colorCount,
            emptyTubes: 2,
            capacity: 4,
            seed: todaySeed
        )
    }

    /// Has user completed today's challenge?
    var isCompletedToday: Bool {
        defaults.string(forKey: "ps_daily_completed") == todayKey
    }

    /// Today's best move count
    var todayMoves: Int? {
        guard isCompletedToday else { return nil }
        let moves = defaults.integer(forKey: "ps_daily_moves")
        return moves > 0 ? moves : nil
    }

    /// Daily streak
    var streak: Int {
        get { defaults.integer(forKey: "ps_daily_streak") }
        set { defaults.set(newValue, forKey: "ps_daily_streak") }
    }

    func completeDaily(moves: Int) {
        guard !isCompletedToday else { return }

        // Check if yesterday was completed for streak
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let yesterdayKey = formatter.string(from: yesterday)

        let lastCompleted = defaults.string(forKey: "ps_daily_completed")
        if lastCompleted == yesterdayKey {
            streak += 1
        } else if lastCompleted != todayKey {
            streak = 1
        }

        defaults.set(todayKey, forKey: "ps_daily_completed")
        defaults.set(moves, forKey: "ps_daily_moves")
    }
}
