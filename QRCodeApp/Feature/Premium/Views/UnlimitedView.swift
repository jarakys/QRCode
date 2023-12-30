//
//  UnlimitedView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 30.12.2023.
//

import SwiftUI

struct OfferView: View {
    var body: some View {
        HStack {
            
        }
    }
}

struct OfferCell: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
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
