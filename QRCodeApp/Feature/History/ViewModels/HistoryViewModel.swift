//
//  HistoryViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation
import Combine
import CoreData

final class HistoryViewModel: BaseViewModel {
    @Published public var isEditing = false
    @Published public var selectedType = 0
    @Published public var sections = [QRCodeEntitySection]()
    @Published public var searchText: String = ""
    @Published public var selectedItems = Set<UUID>()
    @Published public var isSelected: Bool = false
    @Published public var isMultipleSelection: Bool = false
    private let navigationSender: PassthroughSubject<HistoryEventFlow, Never>
    
    private let historyService = HistoryService()
    
    init(navigationSender: PassthroughSubject<HistoryEventFlow, Never>) {
        self.navigationSender = navigationSender
        super.init()
        do {
            try historyService.fetch(isCreated: false)
        } catch {
            print("fetched error \(error)")
        }
    }
    
    override func bind() {
        super.bind()
        
        $selectedItems.map({ !$0.isEmpty }).assign(to: &$isSelected)
        $selectedItems.map({ $0.count > 1 }).assign(to: &$isMultipleSelection)
        
        historyService.emmiter.receive(on: RunLoop.main).sink(receiveValue: { [weak self] sections in
            guard let self else { return }
            self.sections = sections
            print("section count \(sections)")
            
        }).store(in: &cancellable)
        
        $selectedType.dropFirst().sink(receiveValue: { [weak self] type in
            guard let self else { return }
            guard let type = HistorySegmentType(rawValue: type) else { return }
            do {
                switch type {
                case .scanned:
                    try self.historyService.fetch(isCreated: false)
                    
                case .created:
                    try self.historyService.fetch(isCreated: true)
                    
                }
            } catch {
                print("selectedType changed error \(error)")
            }
        }).store(in: &cancellable)
    }
    
    public func itemDidTap(item: QRCodeEntityModel) {
        guard let type = HistorySegmentType(rawValue: selectedType) else { return }
        switch type {
        case .scanned:
            print("scanned")
            
        case .created:
            print("created")
        }
    }
    
    public func deleteDidTap() {
        
    }
    
    public func editDidTap() {
        
    }
    
    public func sortDidTap() {
        
    }
    
    public func addDidTap() {
        
    }
    
    public func save() {
        
    }
}
