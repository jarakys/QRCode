//
//  CreateViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation
import Combine

final class CreateViewModel: BaseViewModel {
    @Published public var items = [CreateQRCodeSectionModel]()
    @Published public var isPremium: Bool = false
    @Published public var showingSheet: Bool = false
    
    private let navigationSender: PassthroughSubject<CreateEventFlow, Never>
    
    public var createCount: Int {
        KeychainManager.shared.get(key: .countCreates, defaultValue: 0)
    }
    
    init(navigationSender: PassthroughSubject<CreateEventFlow, Never>) {
        self.navigationSender = navigationSender
        super.init()
        items.append(CreateQRCodeSectionModel(cellIdentifiers:
                                                [CreateQRCodeTemplateModel(type: .phone),
                                                 CreateQRCodeTemplateModel(type: .email),
                                                 CreateQRCodeTemplateModel(type: .sms),
                                                 CreateQRCodeTemplateModel(type: .url)
                                                ],
                                              sectionIdentifier: .personal))
        items.append(CreateQRCodeSectionModel(cellIdentifiers:
                                                [CreateQRCodeTemplateModel(type: .text),
                                                 CreateQRCodeTemplateModel(type: .wifi),
                                                 CreateQRCodeTemplateModel(type: .location)
                                                ],
                                              sectionIdentifier: .utilities))
        items.append(CreateQRCodeSectionModel(cellIdentifiers:
                                                [CreateQRCodeTemplateModel(type: .telegram),
                                                 CreateQRCodeTemplateModel(type: .facebook),
                                                 CreateQRCodeTemplateModel(type: .instagram),
                                                 CreateQRCodeTemplateModel(type: .twitter),
                                                 CreateQRCodeTemplateModel(type: .whatsApp),
                                                 CreateQRCodeTemplateModel(type: .tikTok),
                                                 CreateQRCodeTemplateModel(type: .spotify),
                                                 CreateQRCodeTemplateModel(type: .snapchat)
                                                ],
                                              sectionIdentifier: .social))
    }
    
    public func templateDidTap(item: CreateQRCodeTemplateModel) {
        navigationSender.send(.create(type: item))
    }
    
    public func premiumDidTap() {
        showingSheet.toggle()
    }
    
    override func bind() {
        super.bind()
        
        SubscriptionManager.shared.$isPremium.assign(to: &$isPremium)
    }
}
