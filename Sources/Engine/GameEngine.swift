import Foundation
import SwiftUI

@Observable @MainActor
final class GameEngine {
    var tubes: [Tube] = []
    var selectedTubeIndex: Int? = nil
    var moveCount: Int = 0
    var isComplete: Bool = false
    var isStuck: Bool = false
    var lastMoveInvalid: Bool = false
    var undoStack: [Move] = []

    private var initialTubes: [Tube] = []
    private(set) var currentLevel: LevelConfig?

    private let sound = SoundManager.shared
    private let store = StoreManager.shared

    // MARK: - Undo limit (free: 3 per level, Pro: unlimited)
    var undoRemaining: Int {
        if store.isPro { return 999 }
        return max(0, 3 - undoUsedCount)
    }
    private var undoUsedCount: Int = 0

    // MARK: - Level Management

    func loadLevel(_ config: LevelConfig) {
        currentLevel = config
        tubes = config.generateTubes()
        initialTubes = tubes
        selectedTubeIndex = nil
        moveCount = 0
        isComplete = false
        isStuck = false
        lastMoveInvalid = false
        undoStack = []
        undoUsedCount = 0
    }

    // MARK: - Moves

    func tapTube(at index: Int) {
        guard !isComplete else { return }
        lastMoveInvalid = false

        if let selected = selectedTubeIndex {
            if selected == index {
                // Deselect
                selectedTubeIndex = nil
                sound.playDeselect()
            } else if canMove(from: selected, to: index) {
                performMove(from: selected, to: index)
                selectedTubeIndex = nil
                sound.playPour()
            } else if !tubes[index].isEmpty {
                // Invalid move — try selecting new source
                if tubes[index].topBall != nil {
                    selectedTubeIndex = index
                    sound.playSelect()
                    lastMoveInvalid = true
                }
            } else {
                // Can't move to empty when rule doesn't allow
                selectedTubeIndex = nil
                sound.playInvalid()
                lastMoveInvalid = true
            }
        } else {
            if !tubes[index].isEmpty && !tubes[index].isComplete {
                selectedTubeIndex = index
                sound.playSelect()
            }
        }
    }

    func canMove(from sourceIdx: Int, to destIdx: Int) -> Bool {
        guard sourceIdx != destIdx,
              sourceIdx >= 0, sourceIdx < tubes.count,
              destIdx >= 0, destIdx < tubes.count else { return false }

        let source = tubes[sourceIdx]
        let dest = tubes[destIdx]

        guard let topBall = source.topBall else { return false }
        guard !dest.isFull else { return false }

        if dest.isEmpty { return true }

        return dest.topBall?.ballColor == topBall.ballColor
    }

    private func performMove(from sourceIdx: Int, to destIdx: Int) {
        guard let ball = tubes[sourceIdx].pop() else { return }
        tubes[destIdx].push(ball)
        moveCount += 1

        let move = Move(fromIndex: sourceIdx, toIndex: destIdx, ball: ball)
        undoStack.append(move)

        checkCompletion()
        if !isComplete {
            checkStuck()
        }
    }

    // MARK: - Undo

    func undo() {
        guard let lastMove = undoStack.popLast() else { return }
        guard undoRemaining > 0 else { return }

        _ = tubes[lastMove.toIndex].pop()
        tubes[lastMove.fromIndex].push(lastMove.ball)
        moveCount = max(0, moveCount - 1)
        isComplete = false
        isStuck = false
        undoUsedCount += 1
        sound.playDeselect()
    }

    // MARK: - Restart

    func restart() {
        tubes = initialTubes
        selectedTubeIndex = nil
        moveCount = 0
        isComplete = false
        isStuck = false
        lastMoveInvalid = false
        undoStack = []
        undoUsedCount = 0
    }

    // MARK: - Extra Tube

    func addExtraTube() {
        guard let config = currentLevel else { return }
        tubes.append(Tube(capacity: config.capacity))
        isStuck = false
    }

    // MARK: - Win Check

    private func checkCompletion() {
        isComplete = tubes.allSatisfy { tube in
            tube.isEmpty || tube.isComplete
        }
        if isComplete {
            sound.playSuccess()
        }
    }

    // MARK: - Stuck Detection

    private func checkStuck() {
        // Check if any valid move exists
        for i in 0..<tubes.count {
            guard !tubes[i].isEmpty, !tubes[i].isComplete else { continue }
            for j in 0..<tubes.count {
                if canMove(from: i, to: j) {
                    isStuck = false
                    return
                }
            }
        }
        isStuck = true
    }

    /// Check if there are any valid moves
    var hasValidMoves: Bool {
        for i in 0..<tubes.count {
            guard !tubes[i].isEmpty, !tubes[i].isComplete else { continue }
            for j in 0..<tubes.count {
                if canMove(from: i, to: j) { return true }
            }
        }
        return false
    }
}
