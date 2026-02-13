//
//  HapticManager.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    // Error haptic for wrong entries
    func errorFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    // Success haptic for completions
    func successFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // Selection haptic for UI interactions
    func selectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    // Impact haptic for button presses
    func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
