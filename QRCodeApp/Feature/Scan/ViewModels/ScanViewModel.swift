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
    
    private let keychainStorage = KeychainManager.shared
    
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
        let scanCounts = keychainStorage.get(key: .countScans, defaultValue: 0)
        do {
            try keychainStorage.set(key: .countScans, value: scanCounts + 1)
        } catch {
            print("setRecognized keychainStorage countScans error: \(error)")
        }
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
