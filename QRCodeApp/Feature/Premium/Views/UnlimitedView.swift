//
//  UnlimitedView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 30.12.2023.
//

import SwiftUI
import Combine
import RevenueCatUI
import RevenueCat

final class PaywallViewModel: BaseViewModel {
    @Published public var items = [OfferViewModel]()
    @Published public var selectedItem: OfferViewModel?
    @Published public var isLoading: Bool = false
    @Published public var isInProgress: Bool = false
    @Published public var showSucces = false
    public var error = PassthroughSubject<Error, Never>()
    
    public let eventSender = PassthroughSubject<PaywallViewModel.Event, Never>()
    
    public var closeDidTap: (() -> Void)?
    
    public var buttonTitle: String {
        selectedItem?.id == "qr_999_1w_3d0" ? String(localized: "Get a free trial") : String(localized: "Continue")
    }

    init(closeDidTap: (() -> Void)? = nil) {
        self.closeDidTap = closeDidTap
        items = [
            OfferViewModel(duration: "12 monthly", save: "Save 80%", price: "$59.99", per: "Year", hintSelected: "Most popular", id: "com.id.some1"),
            OfferViewModel(duration: "7 days", save: "Save 80%", price: "$59.99", per: "Year", hintSelected: "Most popular", id: "com.id.some2"),
            OfferViewModel(duration: "7 days", save: "80%", price: "$59.99", per: "Year", hintSelected: "Most popular", id: "com.id.some3")
        ]
    }
    
    override func bind() {
        super.bind()
        
        SubscriptionManager.shared.$items.sink(receiveValue: { [weak self] items in
            guard let self else { return }
            self.items = items
            self.selectedItem = items.first(where: { $0.id == "qr_999_1w_3d0" })
        }).store(in: &cancellable)
        SubscriptionManager.shared.$isLoading.assign(to: &$isLoading)
        
        SubscriptionManager.shared.$buyInProgress.assign(to: &$isInProgress)
    }
    
    public func restore() {
        Task { @MainActor [weak self] in
            let result = await SubscriptionManager.shared.restorePurchases()
            guard result else { return }
            self?.showSucces = true
            self?.eventSender.send(.dismiss)
        }
    }
    
    public func closeTap() {
        closeDidTap?()
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
                    Image(.paywall2Icon)
                    UnlimitedView()
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
        .padding(.horizontal, 16)
        .onReceive(viewModel.eventSender, perform: { event in
            dismiss()
        })
    }
}

struct PaywallView: View {
    @StateObject public var viewModel: PaywallViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        RevenueCatUI.PaywallView()
//        ZStack {
//            if viewModel.isInProgress {
//                ProgressView()
//                    .scaleEffect(2)
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .tint(.primaryApp)
//                    .zIndex(2)
//            }
//            VStack {
//                ZStack(alignment: .leading) {
//                    HStack {
//                        Image(.closeIcon)
//                            .onTapGesture {
//                                viewModel.closeTap()
//                            }
//                        Spacer()
//                    }
//                    Text("QR Сode Reader | Scanner")
//                        .font(.system(size: 15, weight: .semibold))
//                        .foregroundStyle(.black)
//                        .frame(maxWidth: .infinity, alignment: .center)
//                }
//                ScrollView {
//                    Image(.paywall1Icon)
//                    UnlimitedView()
//                        .padding(.top, 4)
//                }
//                Spacer()
//                if viewModel.isLoading {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle())
//                        .tint(.primaryApp)
//                        .scaleEffect(1.5)
//                } else {
//                    OfferView(viewModel: viewModel)
//                }
//            }
//        }
//        .padding(.horizontal, 16)
//        .onReceive(viewModel.eventSender, perform: { event in
//            dismiss()
//        })
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
    
    init(isSelected: Bool = false, duration: String, save: String, price: String, per: String, hintSelected: String, id: String) {
        self.isSelected = isSelected
        self.duration = duration
        self.save = save
        self.price = price
        self.per = per
        self.hintSelected = hintSelected
        self.id = id
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
        .frame(width: 105)
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
        .frame(width: 108)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.primaryApp, lineWidth: 3)
        )
    }
}

struct UnlimitedView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 12) {
                Text("Unlimited Access To All Features")
                    .foregroundStyle(.primaryTitle)
                    .font(.system(size: 22, weight: .bold))
                    .multilineTextAlignment(.center)
                    
                VStack(alignment: .leading) {
                    HStack(spacing: 8) {
                        Image(.premiumScanIcon)
                        Text("Unlimited Scans QR & Barcodes")
                            .font(.system(size: 12))
                            .foregroundStyle(.primaryTitle)
                            .lineLimit(2)
                    }
                    HStack(spacing: 8) {
                        Image(.premiumDesignIcon)
                        Text("Custom Designed QR Codes")
                            .font(.system(size: 12))
                            .foregroundStyle(.primaryTitle)
                            .lineLimit(2)
                    }
                    HStack(spacing: 8) {
                        Image(.premiumDesignIcon)
                        Text("QR Code Generation for All Categories")
                            .font(.system(size: 12))
                            .foregroundStyle(.primaryTitle)
                            .lineLimit(2)
                    }
                    HStack(spacing: 8) {
                        Image(.noAdsIcon)
                        Text("No Ads")
                            .font(.system(size: 12))
                            .foregroundStyle(.primaryTitle)
                            .lineLimit(2)
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
    UnlimitedView()
}
