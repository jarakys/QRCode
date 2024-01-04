//
//  UnlimitedView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 30.12.2023.
//

import SwiftUI
import Combine
import RevenueCatUI

final class PaywallViewModel: BaseViewModel {
    @Published public var items = [OfferViewModel]()
    @Published public var selectedItem: OfferViewModel?
    @Published public var isLoading: Bool = false
    @Published public var isInProgress: Bool = false
    @Published public var showSucces = false
    @Published public var metadata: OfferMetadataModel?
    public var error = PassthroughSubject<Error, Never>()
    
    public var ad = OpenAd.shared
    
    private let shouldStartSession: Bool
    
    public let eventSender = PassthroughSubject<PaywallViewModel.Event, Never>()
    
    public var closeDidTap: (() -> Void)?
    
    static let sender = PassthroughSubject<PaywallViewModel.Event, Never>()
    
    public var buttonTitle: String {
        selectedItem?.buyButtonTitle ?? String(localized: "Continue")
    }

    init(closeDidTap: (() -> Void)? = nil, shouldStartSession: Bool = false) {
        self.shouldStartSession = shouldStartSession
        self.closeDidTap = closeDidTap
    }
    
    override func bind() {
        super.bind()
        
        SubscriptionManager.shared.$items.sink(receiveValue: { [weak self] items in
            guard let self else { return }
            self.items = items
            self.selectedItem = items.first(where: { $0.id == "qr_999_1w_3d0" })
        }).store(in: &cancellable)
        SubscriptionManager.shared.$isLoading.assign(to: &$isLoading)
        SubscriptionManager.shared.$metadata.assign(to: &$metadata)
        SubscriptionManager.shared.$buyInProgress.assign(to: &$isInProgress)
    }
    
    public func restore() {
        Task { @MainActor [weak self] in
            let result = await SubscriptionManager.shared.restorePurchases()
            guard result else { return }
            self?.showSucces = true
            if self?.shouldStartSession == true {
                Self.sender.send(.shouldStartSession)
            }
            
            self?.eventSender.send(.dismiss)
        }
    }
    
    public func closeTap() {
        closeDidTap?()
        if shouldStartSession == true {
            Self.sender.send(.shouldStartSession)
        }
        eventSender.send(.dismiss)
    }
    
    public func select(item: OfferViewModel) {
        selectedItem = item
    }
    
    public func getPremiumDidTap() {
        guard let selectedItem else { return }
        Task { @MainActor [weak self] in
            guard let self else { return }
            let result = await SubscriptionManager.shared.buy(id: selectedItem.id)
            guard result else { return }
            self.showSucces = true
            self.eventSender.send(.dismiss)
        }
    }
}

// MARK: Event
extension PaywallViewModel {
    enum Event {
        case dismiss
        case shouldStartSession
    }
}

struct Paywall2View: View {
    @StateObject public var viewModel: PaywallViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if viewModel.isInProgress {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.primaryApp)
                    .zIndex(2)
            }
            if let metadata = viewModel.metadata {
                VStack {
                    ZStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            Image(.closeIcon)
                                .onTapGesture {
                                    viewModel.closeTap()
                                }
                        }
                        Text("QR Сode Reader | Scanner")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    ScrollView {
                        Image(metadata.image)
                        UnlimitedView(viewModel: viewModel)
                            .padding(.top, 4)
                    }
                    Spacer()
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.primaryApp)
                    } else {
                        OfferView(viewModel: viewModel)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .onReceive(viewModel.eventSender, perform: { event in
            dismiss()
        })
    }
}

final class PaywallViewModelTest: ObservableObject {
    public var ad = OpenAd.shared
}

struct PaywallView: View {
    @StateObject public var viewModel = PaywallViewModel()
    @Environment(\.dismiss) var dismiss
//    @StateObject var viewModel = PaywallViewModelTest()
    
    public var shouldStartSession: Bool
    public var shouldRequestAd: Bool
    
    var body: some View {
//        RevenueCatUI.PaywallView(displayCloseButton: true)
//            .onRestoreCompleted({ value in
//                SubscriptionManager.shared.isPremium = !value.entitlements.active.isEmpty
//            })
//            .onPurchaseCompleted({ value in
//                SubscriptionManager.shared.isPremium = !value.entitlements.active.isEmpty
//            })
//            .onDisappear(perform: {
//                if shouldStartSession {
//                    PaywallViewModel.sender.send(.shouldStartSession)
//                }
//                if shouldRequestAd, !SubscriptionManager.shared.isPremium {
//                    viewModel.ad.tryToPresentAd()
//                }
//            })
        ZStack {
            if let metadata = viewModel.metadata, !viewModel.isInProgress {
                VStack {
                    ZStack(alignment: .leading) {
                        HStack {
                            Image(.closeIcon)
                                .onTapGesture {
                                    dismiss()
                                }
                            Spacer()
                        }
                        Text("QR Сode Reader | Scanner")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    ScrollView {
                        Image(metadata.image)
                        UnlimitedView(viewModel: viewModel)
                            .padding(.top, 4)
                    }
                    Spacer()
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.primaryApp)
                            .scaleEffect(1.5)
                    } else {
                        OfferView(viewModel: viewModel)
                    }
                }
            } else {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.primaryApp)
                    .zIndex(2)
            }
        }
        .padding(.horizontal, 16)
        .onDisappear(perform: {
            if shouldStartSession {
                PaywallViewModel.sender.send(.shouldStartSession)
            }
            if shouldRequestAd, !SubscriptionManager.shared.isPremium {
                viewModel.ad.tryToPresentAd()
            }
        })
        .onReceive(viewModel.eventSender, perform: { event in
            guard event == .dismiss else { return }
            dismiss()
        })
    }
}

struct OfferView: View {
    @StateObject public var viewModel: PaywallViewModel
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(viewModel.items, id: \.id) { item in
                    if item.id == viewModel.selectedItem?.id {
                        SelectedOfferCell(viewModel: item)
                            .frame(maxWidth: .infinity)
                    } else {
                        OfferCell(viewModel: item)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                viewModel.select(item: item)
                            }
                    }
                }
            }
            Button(action: {
                viewModel.getPremiumDidTap()
            }, label: {
//                if viewModel.isInProgress {
//                    HStack {
//                        Text(viewModel.buttonTitle)
//                            .font(.system(size: 20, weight: .semibold))
//                            .foregroundStyle(.white)
//                            .padding(.vertical, 14)
//                            .frame(maxWidth: .infinity)
//                        ProgressView()
//                            .progressViewStyle(CircularProgressViewStyle())
//                    }
//                } else {
//                   
//                }
                Text(viewModel.buttonTitle)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
            })
            .frame(maxWidth: .infinity)
            .background(.primaryApp)
            .cornerRadius(10)
            .padding(.top, 20)
            .disabled(viewModel.isInProgress)
            Text("No commitments, cancel anytime")
                .foregroundStyle(.secondaryTitle)
                .font(.system(size: 11))
                .padding(.top, 14)
            HStack(alignment: .center) {
                Text("Restore Purchases")
                    .foregroundStyle(.secondaryTitle)
                    .font(.system(size: 11))
                    .multilineTextAlignment(.center)
                    .onTapGesture {
                        viewModel.restore()
                    }
                Link(destination: URL(string: "https://qrscanread.com/terms.html")!, label: {
                    Text("Terms and conditions")
                        .foregroundStyle(.secondaryTitle)
                        .font(.system(size: 11))
                        .multilineTextAlignment(.center)
                })
                Link(destination: URL(string: "https://qrscanread.com/privacy.html")!, label: {
                    Text("Privacy Policy")
                        .foregroundStyle(.secondaryTitle)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 11))
                })
            }
        }
    }
}

final class OfferViewModel: ObservableObject {
    @Published public var isSelected = false
    public let duration: String
    public let save: String
    public let price: String
    public let per: String
    public let hintSelected: String
    public let id: String
    public let buyButtonTitle: String
    
    init(isSelected: Bool = false, duration: String, save: String, price: String, per: String, hintSelected: String, id: String, buyButtonTitle: String) {
        self.isSelected = isSelected
        self.duration = duration
        self.save = save
        self.price = price
        self.per = per
        self.hintSelected = hintSelected
        self.id = id
        self.buyButtonTitle = buyButtonTitle
    }
}

struct OfferCell: View {
    @StateObject public var viewModel: OfferViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.duration)
                .font(.system(size: 11))
                .foregroundStyle(.primaryTitle)
            Text(viewModel.save)
                .font(.system(size: 11, weight: .semibold))
                .padding(.all, 2)
                .background(.green)
                .cornerRadius(3)
                .foregroundStyle(.white)
                .padding(.top, 4)
                .padding(.horizontal, 6)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(viewModel.price)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.primaryTitle)
                .padding(.top, 4)
            Text(viewModel.per)
                .padding(.top, 2)
                .font(.system(size: 11))
                .foregroundStyle(.secondaryTitle)
        }
        .padding(.vertical, 17)
        .frame(width: 112)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1)
        )
    }
}

struct SelectedOfferCell: View {
    @StateObject public var viewModel: OfferViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.hintSelected.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white)
                .background(.primaryApp)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
                .padding(.bottom, 2)
                .background(.primaryApp)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            Text(viewModel.duration)
                .font(.system(size: 11))
                .foregroundStyle(.primaryTitle)
                .padding(.top, 6)
            Text(viewModel.save)
                .font(.system(size: 11, weight: .semibold))
                .padding(.all, 2)
                .background(.green)
                .cornerRadius(3)
                .foregroundStyle(.white)
                .padding(.top, 4)
                .lineLimit(1)
//                .minimumScaleFactor(0.8)
            Text(viewModel.price)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primaryTitle)
                .padding(.top, 4)
            Text(viewModel.per)
                .padding(.top, 2)
                .font(.system(size: 11))
                .foregroundStyle(.secondaryTitle)
        }
        .padding(.bottom, 17)
        .frame(width: 118)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.primaryApp, lineWidth: 3)
        )
    }
}

struct UnlimitedView: View {
    @StateObject public var viewModel: PaywallViewModel
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 12) {
                Text(viewModel.metadata!.finalTitle)
                    .foregroundStyle(.primaryTitle)
                    .font(.system(size: 22, weight: .bold))
                    .multilineTextAlignment(.center)
                    
                VStack(alignment: .leading) {
                    ForEach(viewModel.metadata!.icons, id: \.globalTitle) { item in
                        HStack(spacing: 8) {
                            Image(item.icon)
                            Text(item.finalTitle)
                                .font(.system(size: 12))
                                .foregroundStyle(.primaryTitle)
                                .lineLimit(2)
                        }
                    }
                }
                .lineLimit(2)
                .frame(maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding(.horizontal, 60)
    }
}

#Preview {
    UnlimitedView(viewModel: PaywallViewModel())
}
