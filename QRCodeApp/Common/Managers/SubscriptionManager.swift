//
//  SubscriptionManager.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 27.12.2023.
//

import Foundation
import Combine

final class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    
    @Published public var isPremium: Bool
    
    init() {
        self.isPremium = false
    }
}
