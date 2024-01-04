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
    let duration: [String: String]
    let globalDuration: String
    let globalPer: String
    let globalSelectedHint: String
    let globalSave: String
    let id: String
    let per: [String: String]
    let platformId: String
    let save: [String: String]
    let selectedHint: [String: String]
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
    let icons: [IconMetadataModel]
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
            
            products.enumerated().forEach({ package in
                let productModel = offerMetadata.products[package.offset]
                let duration = productModel.duration[locale] ?? productModel.globalDuration
                let per = productModel.per[locale] ?? productModel.globalPer
                let selectedHint = productModel.selectedHint[locale] ?? productModel.globalSelectedHint
                let save = productModel.save[locale] ?? productModel.globalSave
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
