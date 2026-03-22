import Foundation
import SwiftUI

// MARK: - Ball Color

enum BallColor: Int, Codable, CaseIterable, Identifiable {
    case ruby = 0
    case orange
    case yellow
    case green
    case cyan
    case blue
    case purple
    case pink
    case mint
    case slate

    var id: Int { rawValue }

    var color: Color {
        switch self {
        case .ruby: .ballRuby
        case .orange: .ballOrange
        case .yellow: .ballYellow
        case .green: .ballGreen
        case .cyan: .ballCyan
        case .blue: .ballBlue
        case .purple: .ballPurple
        case .pink: .ballPink
        case .mint: .ballMint
        case .slate: .ballSlate
        }
    }

    /// Symbol overlay for colorblind accessibility
    var symbol: String {
        switch self {
        case .ruby: "circle.fill"
        case .orange: "triangle.fill"
        case .yellow: "star.fill"
        case .green: "diamond.fill"
        case .cyan: "square.fill"
        case .blue: "pentagon.fill"
        case .purple: "hexagon.fill"
        case .pink: "heart.fill"
        case .mint: "bolt.fill"
        case .slate: "moon.fill"
        }
    }

    static func colors(count: Int) -> [BallColor] {
        Array(allCases.prefix(count))
    }
}

// MARK: - Ball

struct Ball: Identifiable, Equatable {
    let id: UUID
    let ballColor: BallColor

    init(color: BallColor) {
        self.id = UUID()
        self.ballColor = color
    }
}

// MARK: - Tube

struct Tube: Identifiable, Equatable {
    let id: UUID
    var balls: [Ball]
    let capacity: Int

    var isEmpty: Bool { balls.isEmpty }
    var isFull: Bool { balls.count >= capacity }
    var topBall: Ball? { balls.last }
    var isComplete: Bool {
        isFull && balls.allSatisfy { $0.ballColor == balls.first?.ballColor }
    }

    init(capacity: Int = 4, balls: [Ball] = []) {
        self.id = UUID()
        self.capacity = capacity
        self.balls = balls
    }

    mutating func push(_ ball: Ball) {
        guard !isFull else { return }
        balls.append(ball)
    }

    @discardableResult
    mutating func pop() -> Ball? {
        balls.popLast()
    }
}

// MARK: - Move

struct Move: Equatable {
    let fromIndex: Int
    let toIndex: Int
    let ball: Ball
}

// MARK: - Level Config

struct LevelConfig: Equatable {
    let levelNumber: Int
    let colorCount: Int
    let tubeCount: Int      // filled tubes
    let emptyTubes: Int
    let capacity: Int
    let seed: UInt64

    var totalTubes: Int { tubeCount + emptyTubes }

    /// Generate a solvable level: start solved, then shuffle
    func generateTubes() -> [Tube] {
        var rng = SeededRNG(seed: seed)
        let colors = BallColor.colors(count: colorCount)

        // Create solved tubes
        var tubes: [Tube] = colors.map { color in
            let balls = (0..<capacity).map { _ in Ball(color: color) }
            return Tube(capacity: capacity, balls: balls)
        }

        // Add empty tubes
        for _ in 0..<emptyTubes {
            tubes.append(Tube(capacity: capacity))
        }

        // Shuffle: perform random valid reverse moves
        let shuffleMoves = colorCount * capacity * 3
        for _ in 0..<shuffleMoves {
            let fromIdx = Int.random(in: 0..<tubes.count, using: &rng)
            let toIdx = Int.random(in: 0..<tubes.count, using: &rng)
            guard fromIdx != toIdx,
                  !tubes[fromIdx].isEmpty,
                  !tubes[toIdx].isFull else { continue }
            if let ball = tubes[fromIdx].pop() {
                tubes[toIdx].push(ball)
            }
        }

        return tubes
    }
}

// MARK: - Seeded RNG

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> UInt64 {
        // xorshift64
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}
