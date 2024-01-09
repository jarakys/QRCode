//
//  SubscriptionManager.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 27.12.2023.
//

import Foundation
import Combine
import RevenueCat

struct ProductMetadataModel: Codable {
    let platformId: String
    let globalBuyButtonTitle: String
    let buyButtonTitle: [String: String]
}

struct IconMetadataModel: Codable {
    let icon: String
    let title: [String: String]
    let globalTitle: String
    
    var finalTitle: String {
        let locale = Locale.autoupdatingCurrent.languageCode ?? "en_US"
        return title[locale] ?? globalTitle
    }
}

struct OfferMetadataModel: Codable {
    let title: [String: String]
    let globalTitle: String
    let icons: [IconMetadataModel] = [
        IconMetadataModel(icon: "premiumScanIcon", title: [:], globalTitle: String(localized: "Unlimited Scans QR & Barcodes")),
        IconMetadataModel(icon: "premiumDesignIcon", title: [:], globalTitle: String(localized: "Custom Designed QR Codes")),
        IconMetadataModel(icon: "premiumGenerationIcon", title: [:], globalTitle: String(localized: "QR Code Generation for All Categories")),
        IconMetadataModel(icon: "noAdsIcon", title: [:], globalTitle: String(localized: "No Ads"))
    ]
    let products: [ProductMetadataModel]
    let image: String
    
    var finalTitle: String {
        let locale = Locale.autoupdatingCurrent.languageCode ?? "en_US"
        return title[locale] ?? globalTitle
    }
}

final class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    @Published public var isLoading = false
    @Published public var items = [OfferViewModel]()
    @Published public var buyInProgress: Bool = false
    @Published public var isPremium: Bool = false
    
    @Published public var metadata: OfferMetadataModel?
    
    public var error = PassthroughSubject<Error, Never>()
    
    private var products = [Package]()
    
    init() {
        isLoading = true
        isPremium = Purchases.shared.cachedCustomerInfo?.activeSubscriptions.isEmpty != true
        Task { @MainActor [unowned self] in
            guard let currentOffer = try await Purchases.shared.offerings().current else {
                isLoading = false
                return
            }
            guard let offerMetadata: OfferMetadataModel = currentOffer.getMetadataValue(for: "offer") else { return }
            self.metadata = offerMetadata
            let locale = Locale.autoupdatingCurrent.languageCode ?? "en_US"
            products = currentOffer.availablePackages
            let durations = [String(localized: "12 monthly"), String(localized: "7 Days"), String(localized: "1 Month")]
            let pers = [String(localized: "per year"), String(localized: "per week"), String(localized: "per month")]
            let selectedHints = [String(localized: "Best value"), String(localized: "MOST POPULAR"), String(localized: "SAVE 53%")]
            let saves = [String(localized: "SAVE 80%"), String(localized: "3 FREE Days"), String(localized: "Save 53%")]
            products.enumerated().forEach({ package in
                let productModel = offerMetadata.products[package.offset]
                let duration = durations[package.offset]
                let per = pers[package.offset]
                let selectedHint = selectedHints[package.offset]
                let save = saves[package.offset]
                let buyButtonTitle = productModel.buyButtonTitle[locale] ?? productModel.globalBuyButtonTitle
                items.append(OfferViewModel(duration: duration, save: save, price: package.element.localizedPriceString, per: per, hintSelected: selectedHint, id: package.element.storeProduct.productIdentifier, buyButtonTitle: buyButtonTitle))
            })
            isLoading = false
        }
    }
    
    public func restorePurchases() async -> Bool {
        await MainActor.run(body: {
            buyInProgress = true
        })
        do {
            let info = try await Purchases.shared.restorePurchases()
            await MainActor.run(body: {
                isPremium = !info.activeSubscriptions.isEmpty
                buyInProgress = false
            })
            
            return true
        } catch {
            await MainActor.run(body: {
                buyInProgress = false
            })
            print(error)
            self.error.send(error)
            return false
        }
    }
    
    public func buy(id: String) async -> Bool {
        guard let item = products.first(where: { $0.storeProduct.productIdentifier == id }) else { return false }
        await MainActor.run(body: {
            buyInProgress = true
        })
        do {
            let result = try await Purchases.shared.purchase(package: item)
            await MainActor.run(body: {
                isPremium = !result.customerInfo.activeSubscriptions.isEmpty
                buyInProgress = false
            })
            
            return true
        } catch {
            await MainActor.run(body: {
                buyInProgress = false
            })
            self.error.send(error)
            return false
        }
    }
}
