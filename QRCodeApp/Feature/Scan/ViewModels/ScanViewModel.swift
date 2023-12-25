//
//  ScanViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation
import Combine
import QRCode

final class ScanViewModel: BaseViewModel {
    @Published public var isFlashOn = false
    
    private let navigationSender: PassthroughSubject<ScanEventFlow, Never>
    public let eventSender = PassthroughSubject<ScanViewModel.Event, Never>()
    
    init(navigationSender: PassthroughSubject<ScanEventFlow, Never>) {
        self.navigationSender = navigationSender
        super.init()
    }
    
    public func splashDidTap() {
        isFlashOn.toggle()
    }
    
    public func setRecognized(string: String) {
        print(string)
        navigationSender.send(.result(qrCodeString: string))
        guard UserDefaultsService.shared.get(key: .vibrationSelected, defaultValue: true) else { return }
        eventSender.send(.vibrate)
    }
    
    public func detect(on image: Data) {
        let qrCodeString = QRCode.DetectQRCode(data: image)
        guard let qrCodeString else { return }
        setRecognized(string: qrCodeString)
    }
}

extension ScanViewModel {
    enum Event {
        case vibrate
    }
}
