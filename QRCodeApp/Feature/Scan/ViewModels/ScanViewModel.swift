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
    @Published public var isPremium = false
    @Published public var showPremium = false
    
    private let navigationSender: PassthroughSubject<ScanEventFlow, Never>
    public let eventSender = PassthroughSubject<ScanViewModel.Event, Never>()
    
    private let keychainStorage = KeychainManager.shared
    
    public var scanCount: Int {
        KeychainManager.shared.get(key: .countScans, defaultValue: 0)
    }
    
    init(navigationSender: PassthroughSubject<ScanEventFlow, Never>) {
        self.navigationSender = navigationSender
        super.init()
    }
    
    public func splashDidTap() {
        isFlashOn.toggle()
    }
    
    override func bind() {
        super.bind()
        
        SubscriptionManager.shared.$isPremium.assign(to: &$isPremium)
    }
    
    public func setRecognized(string: String) {
        let vibrationSelected = UserDefaultsService.shared.get(key: .vibrationSelected, defaultValue: true)
        if vibrationSelected {
            eventSender.send(.vibrate)
        }
        let soundSelected = UserDefaultsService.shared.get(key: .beepSelected, defaultValue: false)
        if soundSelected {
            eventSender.send(.sound)
        }
        guard isPremium || Config.maxScansCount > scanCount  else {
            showPremium = true
            return
        }
        navigationSender.send(.result(qrCodeString: string))
        let scanCounts = keychainStorage.get(key: .countScans, defaultValue: 0)
        do {
            try keychainStorage.set(key: .countScans, value: scanCounts + 1)
        } catch {
            print("setRecognized keychainStorage countScans error: \(error)")
        }
    }
    
    public func detect(on image: Data) {
        guard isPremium || Config.maxScansCount > scanCount  else {
            showPremium = true
            return
        }
        let qrCodeString = QRCode.DetectQRCode(data: image)
        guard let qrCodeString else { return }
        setRecognized(string: qrCodeString)
    }
}

extension ScanViewModel {
    enum Event {
        case vibrate
        case sound
    }
}
