import AVFoundation
import UIKit

@MainActor
final class SoundManager {
    static let shared = SoundManager()

    private var pourPlayer: AVAudioPlayer?
    private var clickPlayer: AVAudioPlayer?
    private var successPlayer: AVAudioPlayer?
    private var errorPlayer: AVAudioPlayer?

    var isSoundEnabled: Bool {
        get { UserDefaults.standard.object(forKey: "ps_sound") as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: "ps_sound") }
    }

    private init() {}

    /// Play pour/move sound
    func playPour() {
        guard isSoundEnabled else { return }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    /// Play invalid move
    func playInvalid() {
        guard isSoundEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    /// Play level complete
    func playSuccess() {
        guard isSoundEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    /// Play tube select
    func playSelect() {
        guard isSoundEnabled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    /// Play deselect
    func playDeselect() {
        guard isSoundEnabled else { return }
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
}
