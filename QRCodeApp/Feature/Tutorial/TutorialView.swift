//
//  TutorialView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 30.12.2023.
//

import SwiftUI

struct TutorialView: View {
    @StateObject public var viewModel = TutorialViewModel()
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $viewModel.currentPage) {
                    ForEach(viewModel.pages, id: \.title) { page in
                        makePage(page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxHeight: .infinity)
            HStack(spacing: 10) {
                ForEach(viewModel.pages, id: \.title) { page in
                    Circle()
                        .fill(viewModel.currentPage == page.id ? .primaryApp : .unselectedPage)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 19)
            Button(action: {
                viewModel.continueDidTap()
            }, label: {
                Text("Continue")
                    .foregroundStyle(.white)
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(.primaryApp)
            })
            .cornerRadius(10)
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func makePage(_ page: TutorialPage) -> some View {
        TutorialPageView(page: page)
    }
}

#Preview {
    TutorialView()
}
