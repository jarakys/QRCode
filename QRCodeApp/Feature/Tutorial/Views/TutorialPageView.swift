//
//  TutorialPageView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 30.12.2023.
//

import SwiftUI

struct TutorialPageView: View {
    let page: TutorialPage
    var body: some View {
        VStack {
            Image(page.image)
                .padding(.top, 24)
//                .frame(maxHeight: .infinity)
//                .resizable()/
            Spacer()
            Text(page.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.primaryTitle)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.01)
            Text(page.description)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primaryTitle)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.01)
                .padding(.top, 20)
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
