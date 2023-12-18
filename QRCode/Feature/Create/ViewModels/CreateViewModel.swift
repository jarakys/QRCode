//
//  CreateViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation
import Combine

final class CreateViewModel: ObservableObject {
    @Published public var items = [CreateQRCodeSectionModel]()
    
    init() {
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
        
    }
    
    public func premiumDidTap() {
        
    }
}
