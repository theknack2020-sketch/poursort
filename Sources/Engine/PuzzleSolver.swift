import Foundation

/// BFS solver to verify level solvability and compute optimal move count
struct PuzzleSolver {

    struct State: Hashable {
        let tubes: [[Int]] // color indices per tube

        func hash(into hasher: inout Hasher) {
            // Sort tubes for canonical form (tube order doesn't matter)
            let sorted = tubes.sorted { a, b in
                if a.count != b.count { return a.count < b.count }
                for (x, y) in zip(a, b) {
                    if x != y { return x < y }
                }
                return false
            }
            hasher.combine(sorted)
        }

        static func == (lhs: State, rhs: State) -> Bool {
            lhs.tubes.sorted { a, b in
                if a.count != b.count { return a.count < b.count }
                for (x, y) in zip(a, b) {
                    if x != y { return x < y }
                }
                return false
            } == rhs.tubes.sorted { a, b in
                if a.count != b.count { return a.count < b.count }
                for (x, y) in zip(a, b) {
                    if x != y { return x < y }
                }
                return false
            }
        }
    }

    /// Check if a puzzle state is solved
    static func isSolved(_ state: State, capacity: Int) -> Bool {
        state.tubes.allSatisfy { tube in
            tube.isEmpty || (tube.count == capacity && Set(tube).count == 1)
        }
    }

    /// Find all valid moves from a state
    static func validMoves(from state: State, capacity: Int) -> [(from: Int, to: Int)] {
        var moves: [(Int, Int)] = []
        for i in 0..<state.tubes.count {
            guard let topBall = state.tubes[i].last else { continue }
            // Don't move from a completed tube
            if state.tubes[i].count == capacity && Set(state.tubes[i]).count == 1 { continue }

            for j in 0..<state.tubes.count {
                guard i != j else { continue }
                guard state.tubes[j].count < capacity else { continue }

                if state.tubes[j].isEmpty {
                    // Don't move to empty if source is single-color (pointless)
                    if Set(state.tubes[i]).count == 1 { continue }
                    moves.append((i, j))
                } else if state.tubes[j].last == topBall {
                    moves.append((i, j))
                }
            }
        }
        return moves
    }

    /// Apply a move to a state
    static func applyMove(_ state: State, from: Int, to: Int) -> State {
        var tubes = state.tubes
        if let ball = tubes[from].last {
            tubes[from].removeLast()
            tubes[to].append(ball)
        }
        return State(tubes: tubes)
    }

    /// BFS solve — returns optimal move count or nil if unsolvable
    /// Limited to maxStates to prevent memory explosion
    static func solve(tubes: [[Int]], capacity: Int, maxStates: Int = 50000) -> Int? {
        let initial = State(tubes: tubes)
        if isSolved(initial, capacity: capacity) { return 0 }

        var visited: Set<State> = [initial]
        var queue: [(State, Int)] = [(initial, 0)]
        var head = 0

        while head < queue.count {
            let (current, depth) = queue[head]
            head += 1

            if visited.count > maxStates { return nil } // too complex, assume solvable

            for (from, to) in validMoves(from: current, capacity: capacity) {
                let next = applyMove(current, from: from, to: to)

                if isSolved(next, capacity: capacity) {
                    return depth + 1
                }

                if !visited.contains(next) {
                    visited.insert(next)
                    queue.append((next, depth + 1))
                }
            }
        }

        return nil // unsolvable
    }

    /// Quick check — is this puzzle solvable?
    static func isSolvable(tubes: [[Int]], capacity: Int) -> Bool {
        solve(tubes: tubes, capacity: capacity) != nil
    }

    /// Convert game tubes to solver format
    static func toSolverFormat(_ gameTubes: [Tube]) -> [[Int]] {
        gameTubes.map { tube in
            tube.balls.map { $0.ballColor.rawValue }
        }
    }
}
