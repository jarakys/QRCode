//
//  HistoryViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation
import Combine

final class HistoryViewModel: BaseViewModel {
    @Published public var isEditing = false
    @Published public var selectedType = HistorySegmentType.scanned
    private let navigationSender: PassthroughSubject<HistoryEventFlow, Never>
    
    init(navigationSender: PassthroughSubject<HistoryEventFlow, Never>) {
        self.navigationSender = navigationSender
    }
    
    public func deleteDidTap() {
        
    }
    
    public func editDidTap() {
        
    }
    
    public func save() {
        
    }
}
