//
//  CreateCoordinatorViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation
import Combine

final class CreateCoordinatorViewModel: BaseViewModel {
    public let navigationSender = PassthroughSubject<CreateEventFlow, Never>()
    @Published public var paths = [CreateFlow]()
    
    override func bind() {
        super.bind()
        
        navigationSender.sink(receiveValue: { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .selection:
                paths.append(.selection)
                
            case let .create(type):
                paths.append(.create(type: type))
                
            case let .result(finalString, type):
                paths.append(.result(finalString: finalString, type: type))
                
            case .premium:
                paths.append(.premium)
                
            case .back:
                paths.removeLast()
                
            case .popToRoot:
                paths = []
            }
        }).store(in: &cancellable)
    }
    
    public func selectionViewModel() -> CreateViewModel {
        CreateViewModel(navigationSender: navigationSender)
    }
    
    public func createViewModel(type: QRCodeFormat) -> CreateContentLinkViewModel {
        CreateContentLinkViewModel(format: type, navigationSender: navigationSender)
    }
    
    public func resultViewModel(type: QRCodeFormat, finalString: String) -> CreateResultQRCodeViewModel {
        CreateResultQRCodeViewModel(qrCodeFormat: type, qrCodeString: finalString)
    }
}
