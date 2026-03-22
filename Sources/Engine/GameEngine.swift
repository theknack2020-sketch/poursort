import Foundation
import SwiftUI

@Observable @MainActor
final class GameEngine {
    var tubes: [Tube] = []
    var selectedTubeIndex: Int? = nil
    var moveCount: Int = 0
    var isComplete: Bool = false
    var undoStack: [Move] = []

    private var initialTubes: [Tube] = []
    private(set) var currentLevel: LevelConfig?

    // MARK: - Level Management

    func loadLevel(_ config: LevelConfig) {
        currentLevel = config
        tubes = config.generateTubes()
        initialTubes = tubes
        selectedTubeIndex = nil
        moveCount = 0
        isComplete = false
        undoStack = []
    }

    // MARK: - Moves

    func tapTube(at index: Int) {
        guard !isComplete else { return }

        if let selected = selectedTubeIndex {
            if selected == index {
                // Deselect
                selectedTubeIndex = nil
            } else if canMove(from: selected, to: index) {
                performMove(from: selected, to: index)
                selectedTubeIndex = nil
            } else if !tubes[index].isEmpty {
                // Select new source
                selectedTubeIndex = index
            } else {
                selectedTubeIndex = nil
            }
        } else {
            if !tubes[index].isEmpty {
                selectedTubeIndex = index
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
    }

    // MARK: - Undo

    func undo() {
        guard let lastMove = undoStack.popLast() else { return }
        _ = tubes[lastMove.toIndex].pop()
        tubes[lastMove.fromIndex].push(lastMove.ball)
        moveCount = max(0, moveCount - 1)
        isComplete = false
    }

    // MARK: - Restart

    func restart() {
        tubes = initialTubes
        selectedTubeIndex = nil
        moveCount = 0
        isComplete = false
        undoStack = []
    }

    // MARK: - Extra Tube

    func addExtraTube() {
        guard let config = currentLevel else { return }
        tubes.append(Tube(capacity: config.capacity))
    }

    // MARK: - Win Check

    private func checkCompletion() {
        isComplete = tubes.allSatisfy { tube in
            tube.isEmpty || tube.isComplete
        }
    }
}
