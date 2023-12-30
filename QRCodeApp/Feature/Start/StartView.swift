//
//  StartView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 30.12.2023.
//

import SwiftUI

final class StartViewModel: ObservableObject {
    var didTap: (() -> Void)?
    
    init(didTap: (() -> Void)?) {
        self.didTap = didTap
    }
    
    public func startDidTap() {
        didTap?()
    }
}

struct StartView: View {
    @StateObject public var viewModel: StartViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("QR code reader \n& scanner")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primaryTitle)
                    .multilineTextAlignment(.center)
                Spacer()
            }

            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            VStack(alignment: .center) {
                Spacer()
                Image(.startLogoIcon)
                Spacer()
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            VStack(alignment: .center) {
                Spacer()
                    .frame(maxHeight: .infinity)
                Text("By continuing you agree to the")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.titleTextField)
                    .font(.system(size: 12))
                Link("Term and Privacy Policy", destination:
                    URL(string: "https://qrscanread.com/privacy.html")!
                )
                .font(.system(size: 12))
                .padding(.bottom, 30)
                Button(action: {
                    viewModel.startDidTap()
                }, label: {
                    Text("Start")
                        .foregroundStyle(.white)
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(.primaryApp)
                })
                .cornerRadius(10)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 16)
    }
}

