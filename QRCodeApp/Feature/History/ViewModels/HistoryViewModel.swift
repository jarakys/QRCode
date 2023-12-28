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
    @Published public var shouldEdit = false

    private var privateItems = [QRCodeEntitySection]()
    
    private let keychainStorage: KeychainManager = .shared
    private let subscriptionManager: SubscriptionManager
    private let navigationSender: PassthroughSubject<HistoryEventFlow, Never>
    
    private let historyService = HistoryService()
    
    var lastSection: QRCodeEntitySection? {
        sections.last
    }
    
    public var countScans: Int {
        var countScans = keychainStorage.get(key: .countScans, defaultValue: 0)
        countScans = countScans == 0 ? sections.flatMap({ $0.items }).count : countScans
        countScans = countScans > Config.maxScansCount ? Config.maxScansCount : countScans
        return countScans
    }
    
    public var countCreates: Int {
        var countCreates = keychainStorage.get(key: .countCreates, defaultValue: 0)
        countCreates = countCreates == 0 ? sections.flatMap({ $0.items }).count : countCreates
        countCreates = countCreates > Config.maxCreatesCount ? Config.maxCreatesCount : countCreates
        return countCreates
    }
    
    public var shouldShowUnlockButton: Bool {
        if selectedType == 0 {
            return countScans >= Config.maxScansCount
        } else {
            return countCreates >=  Config.maxCreatesCount
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
            self.privateItems = sections
            let searchItems = self.search(searchText: self.searchText)
            let filteredItems = self.filter(sortType: self.sortType, items: searchItems)
            self.sections = filteredItems
            print("section count \(sections)")
            guard sections.isEmpty else { return }
            self.shouldEdit = false
        }).store(in: &cancellable)
        
        $selectedType.dropFirst().sink(receiveValue: { [weak self] type in
            guard let self else { return }
            guard let type = HistorySegmentType(rawValue: type) else { return }
            self.shouldEdit = false
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
                
            case .alhabet:
                break
            }
            let searchItems = self.search(searchText: self.searchText)
            let filteredItems = self.filter(sortType: value, items: searchItems)
            self.sections = filteredItems
            
        }).store(in: &cancellable)
        
        $searchText.sink(receiveValue: { [weak self] text in
            guard let self else { return }
            let searchItems = self.search(searchText: text)
            let filteredItems = self.filter(sortType: self.sortType, items: searchItems)
            self.sections = filteredItems
        }).store(in: &cancellable)
    }
    
    private func search(searchText: String) -> [QRCodeEntitySection] {
        guard !searchText.isEmpty else {
            return privateItems
        }
        let filteredSections = privateItems.map { section in
            let filteredItems = section.items.filter { $0.qrCodeFormat.description.localizedCaseInsensitiveContains(searchText) }
            return QRCodeEntitySection(title: section.title, items: filteredItems)
        }
        return filteredSections
    }
    
    private func filter(sortType: HistorySortType, items: [QRCodeEntitySection]) -> [QRCodeEntitySection] {
        return items.map { section in
            let sortedItems: [QRCodeEntityModel] = {
                switch sortType {
                case .alhabet:
                    return section.items.sorted(by: { $0.qrCodeFormat.description > $1.qrCodeFormat.description })
                    
                case .manual:
                    return section.items.sorted(by: { $0.order < $1.order })
                }
            }()
            return QRCodeEntitySection(title: section.title, items: sortedItems)
        }
    }
    
    public func scanDidTap() {
        navigationSender.send(.scans)
    }
    
    public func createDidTap() {
        navigationSender.send(.create)
    }
    
    public func deleteDidTap() {
        let items = sections.flatMap({ $0.items }).filter({ selectedItems.contains($0.id) })
        do {
            try CoreDataManager.shared.removeQRCodes(ids: items.map({ $0.id }))
            selectedItems.removeAll()
        } catch {
            print("deleteDidTap error \(error)")
        }
    }
    
    public func editDidTap() {
        guard let first = privateItems.flatMap({ $0.items }).first(where: { selectedItems.contains($0.id) }) else { return }
        navigationSender.send(.editableDetails(model: first))
        shouldEdit = false
    }
    
    public func itemDidTap(model: QRCodeEntityModel) {
        guard !isEditing else { return }
        navigationSender.send(.details(model: model))
    }
    
    public func unlockDidTap() {
        
    }
    
    public func selectAll() {
        privateItems.flatMap({ $0.items }).forEach({ item in
            selectedItems.insert(item.id)
        })
    }
    
    public func shareDidTap() {
        let items = privateItems.flatMap({ $0.items }).filter({ selectedItems.contains($0.id) })
        let images = items.map({ $0.image })
        ShareActivityManager.share(datas: images)
        shouldEdit = false
    }
    
    private func saveAfterMove() {
        sections.forEach({ section in
            section.items.enumerated().forEach({ item in
                print("\(item.element.qrCodeFormat.description) on position \(item.offset)")
                item.element.coreEntity.order = NSNumber(value: item.offset)
            })
        })
        do {
            try CoreDataManager.shared.context.save()
        } catch {
            print("saveAfterMove error \(error)")
        }
    }
    
    public func editListDidTap(isEditing: Bool) {
        guard self.isEditing != isEditing else { return }
        if !isEditing && sortType == .manual, editType != .selection {
            saveAfterMove()
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
    
    public func move(from source: IndexSet, to destination: Int, section: QRCodeEntitySection) {
        print("destination \(destination)")
        section.items.move(fromOffsets: source, toOffset: destination)
    }
}
