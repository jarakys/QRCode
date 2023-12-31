//
//  UnlimitedView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 30.12.2023.
//

import SwiftUI

//struct

struct OfferView: View {
    var body: some View {
        VStack {
            HStack(spacing: 23) {
                OfferCell(viewModel: OfferViewModel(duration: "12 monthly", save: "Save 80%", price: "$49,99", per: "per year", hintSelected: "Most Popular"))
                OfferCell(viewModel: OfferViewModel(duration: "12 monthly", save: "Save 80%", price: "$49,99", per: "per year", hintSelected: "Most Popular"))
                OfferCell(viewModel: OfferViewModel(duration: "12 monthly", save: "Save 80%", price: "$49,99", per: "per year", hintSelected: "Most Popular"))
            }
            Button(action: {
                
            }, label: {
                Text("Get a free tria")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
            })
            .frame(maxWidth: .infinity)
            .background(.primaryApp)
            .padding(.top, 30)
            Text("No commitments, cancel anytime")
                .foregroundStyle(.secondaryTitle)
                .padding(.top, 14)
            HStack(alignment: .center) {
                Text("Restore Purchases")
                Text("Terms of Use")
                Text("Privacy Policy")
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
    
    init(isSelected: Bool = false, duration: String, save: String, price: String, per: String, hintSelected: String) {
        self.isSelected = isSelected
        self.duration = duration
        self.save = save
        self.price = price
        self.per = per
        self.hintSelected = hintSelected
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
                .padding(.all, 2)
                .background(.green)
                .cornerRadius(3)
                .foregroundStyle(.white)
            Text(viewModel.price)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primaryTitle)
            Text(viewModel.per)
                .font(.system(size: 11))
                .foregroundStyle(.secondaryTitle)
        }
        .padding(.vertical, 17)
        .padding(.horizontal, 13)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1)
        )
    }
}

struct UnlimitedView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 12) {
                Text("Unlimited Access To All Features")
                    .foregroundStyle(.primaryTitle)
                    .font(.system(size: 22, weight: .bold))
                VStack {
                    HStack(spacing: 8) {
                        Image(.premiumScanIcon)
                        Text("Unlimited Scans QR & Barcodes")
                            .font(.system(size: 12))
                            .foregroundStyle(.primaryTitle)
                    }
                    HStack(spacing: 8) {
                        Image(.premiumDesignIcon)
                        Text("Custom Designed QR Codes")
                            .font(.system(size: 12))
                            .foregroundStyle(.primaryTitle)
                    }
                    HStack(spacing: 8) {
                        Image(.premiumDesignIcon)
                        Text("QR Code Generation for All Categories")
                            .font(.system(size: 12))
                            .foregroundStyle(.primaryTitle)
                    }
                    HStack(spacing: 8) {
                        Image(.noAdsIcon)
                        Text("No Ads")
                            .font(.system(size: 12))
                            .foregroundStyle(.primaryTitle)
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    UnlimitedView()
}
