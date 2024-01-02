//
//  MainTapBarViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 27.12.2023.
//

import Foundation
import Combine

class MainTapBarViewModel: BaseViewModel {
    @Published public var tabSelection = 0
    @Published public var isPremium = false
    
    public var ad = OpenAd()
    
    override func bind() {
        super.bind()
        
        SubscriptionManager.shared.$isPremium.assign(to: &$isPremium)
    }
}
