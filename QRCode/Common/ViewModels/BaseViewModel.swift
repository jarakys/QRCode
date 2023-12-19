//
//  BaseViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    public var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    public func bind() {
        
    }
}
