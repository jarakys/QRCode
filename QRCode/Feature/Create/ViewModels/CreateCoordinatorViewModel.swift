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
                
            case .create(let type):
                paths.append(.create(type: type))
                
            case .result:
                paths.append(.result)
                
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
    
    public func createViewModel() {
        
    }
    
    public func resultViewModel() {
        
    }
}
