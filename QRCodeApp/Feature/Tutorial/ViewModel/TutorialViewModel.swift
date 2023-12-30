//
//  TutorialViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 30.12.2023.
//

import Combine
import SwiftUI

final class TutorialViewModel: ObservableObject {
    @Published public var currentPage = 0
    @Published public var pages = [TutorialPage.intro, .designedFor]
    
    public var passedDidTap: (() -> Void)?
    
    init(passedDidTap: (() -> Void)?) {
        self.passedDidTap = passedDidTap
    }
    
    public func continueDidTap() {
        guard currentPage < pages.count - 1 else {
            passedDidTap?()
            return
        }
        withAnimation(.linear) {
            currentPage += 1
        }
    }
}
