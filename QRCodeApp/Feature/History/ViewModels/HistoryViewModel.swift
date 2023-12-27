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
    @Published public var showAlert: Bool = false
    @Published public var sortType: HistorySortType = .alhabet
    @Published public var editType: EditType = .selection
    @Published public var isPremium: Bool = false
    
    private let keychainStorage: KeychainManager = .shared
    private let subscriptionManager: SubscriptionManager
    private let navigationSender: PassthroughSubject<HistoryEventFlow, Never>
    
    private let historyService = HistoryService()
    
    var lastSection: QRCodeEntitySection? {
        sections.last
    }
    
    public var countScans: Int {
        var countScans = (try? keychainStorage.get(key: .countScans, defaultValue: 0) ) ?? 0
        countScans = countScans == 0 ? sections.flatMap({ $0.items }).count : countScans
        countScans = countScans > 5 ? 5 : countScans
        return countScans
    }
    
    public var countCreates: Int {
        var countCreates = (try? keychainStorage.get(key: .countCreates, defaultValue: 0) ) ?? 0
        countCreates = countCreates == 0 ? sections.flatMap({ $0.items }).count : countCreates
        countCreates = countCreates > 5 ? 5 : countCreates
        return countCreates
    }
    
    public var shouldShowUnlockButton: Bool {
        if selectedType == 0 {
            return countCreates >= 5
        } else {
            return countScans >= 4
        }
    }
    
    init(subscriptionManager: SubscriptionManager,
         navigationSender: PassthroughSubject<HistoryEventFlow, Never>) {
        self.navigationSender = navigationSender
        self.subscriptionManager = subscriptionManager
        super.init()
        do {
            try historyService.fetch(isCreated: false)
        } catch {
            print("fetched error \(error)")
        }
    }
    
    override func bind() {
        super.bind()
        
        subscriptionManager.$isPremium.assign(to: &$isPremium)
        
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
        
        $sortType.sink(receiveValue: { [weak self] value in
            guard let self else { return }
            
            switch value {
            case .manual:
                self.editType = .move
                
            case .alhabet: break
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
    
    public func editListDidTap(isEditing: Bool) {
        guard self.isEditing != isEditing else { return }
        if !isEditing && sortType == .manual, editType != .selection {
            editType = .selection
        }
        self.isEditing = isEditing
    }
    
    public func sortDidTap() {
        showAlert.toggle()
    }
    
    public func setSort(type: HistorySortType) {
        sortType = type
    }
    
    public func save() {
        
    }
}
