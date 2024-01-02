//
//  SubscriptionManager.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 27.12.2023.
//

import Foundation
import Combine
import RevenueCat

final class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    @Published public var isLoading = false
    @Published public var items = [OfferViewModel]()
    @Published public var buyInProgress: Bool = false
    @Published public var isPremium: Bool = false
    
    public var error = PassthroughSubject<Error, Never>()
    
    private var products = [StoreProduct]()
    
    init() {
        isLoading = true
        isPremium = Purchases.shared.cachedCustomerInfo?.activeSubscriptions.isEmpty != true
        Task { @MainActor [unowned self] in
            let offerings = await Purchases.shared.products(["qr_1499_1m", "qr_999_1w_3d0", "qr_4999_1y"])
            products = offerings
            items.append(OfferViewModel(duration: String(localized: "12 monthly"), save: String(localized: "SAVE 80%"), price: offerings.first(where: { $0.productIdentifier == "qr_4999_1y" })?.localizedPriceString ?? "", per: String(localized: "per year"), hintSelected: String(localized: "Best value"), id: "qr_4999_1y"))
            
            items.append(OfferViewModel(duration: String(localized: "7 Days"), save: String(localized: "3 FREE Days"), price: offerings.first(where: { $0.productIdentifier == "qr_999_1w_3d0" })?.localizedPriceString ?? "", per: String(localized: "per week"), hintSelected: String(localized: "MOST POPULAR"), id: "qr_999_1w_3d0"))
            
            items.append(OfferViewModel(duration: String(localized: "1 Month"), save: String(localized: "Save 53%"), price: offerings.first(where: { $0.productIdentifier == "qr_1499_1m" })?.localizedPriceString ?? "", per: String(localized: "per month"), hintSelected: String(localized: "SAVE 53%"), id: "qr_1499_1m"))
            
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
        guard let item = products.first(where: { $0.productIdentifier == id }) else { return false }
        await MainActor.run(body: {
            buyInProgress = true
        })
        do {
            let result = try await Purchases.shared.purchase(product: item)
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
