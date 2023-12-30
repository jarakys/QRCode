//
//  TutorialViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 30.12.2023.
//

import Combine

final class TutorialViewModel: ObservableObject {
    @Published public var currentPage = 0
    @Published public var pages = [TutorialPage.intro, .designedFor]
    
    public func continueDidTap() {
        guard currentPage < pages.count - 1 else {
            openPremiumDidTap()
            return
        }
        currentPage += 1
    }
    
    public func openPremiumDidTap() {
        
    }
}
