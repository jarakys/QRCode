//
//  SelectLanguageViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation
import Combine

final class SelectLanguageViewModel: BaseViewModel {
    private let allItems: [LanguageModel]
    @Published public var items: [LanguageModel]
    @Published public var selectedLanguage: LanguageModel
    @Published public var searchText: String = ""
    
    private let communicationBus: PassthroughSubject<SettingsEventBus, Never>
    
    init(communicationBus: PassthroughSubject<SettingsEventBus, Never>) {
        let tmpItems = LanguageType.allCases.map({ LanguageModel(isSelected: $0 == .english, item: $0) })
        allItems = tmpItems
        items = tmpItems
        self.communicationBus = communicationBus
        self.selectedLanguage = tmpItems.first(where: { $0.isSelected }) ?? tmpItems[0]
    }
    
    override func bind() {
        super.bind()
        
        $searchText.dropFirst().sink(receiveValue: { [weak self] searchText in
            guard let self else { return }
            guard !searchText.isEmpty else {
                self.items = allItems
                return
            }
            self.items = allItems.filter({ $0.item.description.contains(searchText) })
        }).store(in: &cancellable)
    }
    
    public func didClick(on item: LanguageModel) {
        selectedLanguage.isSelected = false
        selectedLanguage = item
        selectedLanguage.isSelected = true
        communicationBus.send(.languageSelected(item.item))
    }
}
