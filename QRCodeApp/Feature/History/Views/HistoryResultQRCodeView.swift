//
//  HistoryResultQRCodeView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import SwiftUI
import QRCode

struct HistoryResultQRCodeView: View {
    @StateObject public var viewModel: HistoryResultQRCodeViewModel
    @State public var showToast = false
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .zIndex(3)
            }
            ScrollView {
                VStack(spacing: 10) {
                    Spacer()
                        .frame(height: 6)
                        .background(.red)
                    Text(viewModel.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.createResultTitle)
                    QRCodeDocumentUIView(document: viewModel.qrCodeDocument)
                        .frame(width: 240, height: 240)
                    Text(viewModel.dateString)
                        .font(.system(size: 13))
                        .foregroundStyle(.titleTextField)
                    HStack {
                        Text("Ad block")
                    }
                    .frame(height: 80)
                    .background(.white)
                    .padding(.top, 24)
                    ForEach(viewModel.items, id: \.title) { item in
                        TitledContainerView(title: item.title, value: item.value)
                            .onTapGesture(perform: { [weak item] in
                                UIPasteboard.general.string = item?.value
                                viewModel.eventSender.send(.copied)
                            })
                    }
                    .padding(.horizontal, 16)
                }
                Spacer()
                    .frame(height: 100)
            }
            VStack {
                Spacer()
                shareSection()
                    .padding(.bottom, 16)
            }
        }
        .disabled(viewModel.isLoading)
        .frame(maxWidth: .infinity)
        .background(.secondaryBackground)
        .navigationTitle("Scan Result")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, 1)
        .simpleToast(isPresented: $showToast, options: .init(alignment: Alignment.bottom, hideAfter: 0.7), content: {
            Label("Copied", systemImage: "info.circle")
                .padding(.all, 8)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding(.bottom)
        })
        .onReceive(viewModel.eventSender, perform: { item in
            showToast = item == .copied
        })
    }
    
    @ViewBuilder
    public func shareSection() -> some View {
        HStack(alignment: .center) {
            Button(action: {
                viewModel.shareInSafary(completion: { path in
                    UIApplication.shared.open(URL(string: path)!)
                })
            }, label: {
                Label("Open in Safari", image: "safariIcon")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.primaryApp)
                    .cornerRadius(10)
            })
            Button(action: {
                viewModel.share()
            }, label: {
                Label("Share", image: "shareIcon")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.primaryApp)
                    .cornerRadius(10)
            })
        }
    }
}
