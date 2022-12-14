//
//  HapticEngineManager.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/21.
//

import UIKit
import KuringCommons

/// - NOTE: [human interface guideline](https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/haptics/)
class HapticManager {
    static let shared = HapticManager()
    
    private var impactFeedback: UIImpactFeedbackGenerator?
    private var notificationFeedback: UINotificationFeedbackGenerator?
    
    func setupGenerator() {
        impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback?.prepare()
        notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback?.prepare()
    }
    
    func createImpact() {
        impactFeedback?.impactOccurred()
        #if targetEnvironment(simulator)
        Logger.debug("ππΌ μν©νΈ νΌλλ°±: λ(μ€)!")
        #endif
    }
    
    func createNotification(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedback?.notificationOccurred(notificationType)
        #if targetEnvironment(simulator)
        switch notificationType {
        case .error:
            Logger.debug("ππΌ μν©νΈ νΌλλ°±: μ€μ€κ°μ½!")
        case .success:
            Logger.debug("ππΌ μν©νΈ νΌλλ°±: μ½κ°!")
        case .warning:
            Logger.debug("ππΌ μν©νΈ νΌλλ°±: κ°μ½!")
        default:
            Logger.debug("ππΌ μν©νΈ νΌλλ°±: ?!")
        }
        #endif
    }
    
    func release() {
        impactFeedback = nil
        notificationFeedback = nil
    }
}
