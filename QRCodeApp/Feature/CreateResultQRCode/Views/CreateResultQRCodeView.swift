//
//  CreateResultQRCodeView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import SwiftUI
import Combine
import QRCode
import SimpleToast

struct CreateResultQRCodeView: View {
    @StateObject public var viewModel: CreateResultQRCodeViewModel
    @State public var showToast = false
    
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 16)
            VStack(spacing: 10) {
                Text(viewModel.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.createResultTitle)
                QRCodeDocumentUIView(document: viewModel.qrCodeDocument)
                    .frame(width: 240, height: 240)
                Text(viewModel.dateString)
                    .font(.system(size: 13))
                    .foregroundStyle(.titleTextField)
                VStack(spacing: 0) {
                    HStack(spacing: 10) {
                        Image(ImageResource.changeDesignIcon)
                        Text("Change Design")
                            .font(.system(size: 16))
                            .foregroundStyle(.primaryTitle)
                        Spacer()
                        Text("Pro")
                            .font(.system(size: 17))
                            .foregroundStyle(.secondaryTextField)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .onTapGesture(perform: {
                        viewModel.changedDesignDidTap()
                    })
                    Divider()
                        .padding(.leading, 16)
                    HStack(spacing: 10) {
                        Image(ImageResource.editContentIcon)
                        Text("Edit content")
                            .font(.system(size: 16))
                            .foregroundStyle(.primaryTitle)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .onTapGesture(perform: {
                        viewModel.editContentDidTap()
                    })
                }
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.top, 10)
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
        .frame(maxWidth: .infinity)
        .background(.secondaryBackground)
        .navigationTitle("Creation Result")
        .padding(.top, 1)
        .simpleToast(isPresented: $showToast, options: .init(alignment: Alignment.bottom, hideAfter: 0.7), content: {
            Label("Copied", systemImage: "info.circle")
                .padding(.all, 8)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding(.bottom)
        })
        .toolbar(content: {
            if viewModel.isDeletable {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        viewModel.deleteDidTap()
                    }, label: {
                        Image(.hisotryTrashIcon)
                    })
                })
            }
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

#Preview {
    CreateResultQRCodeView(viewModel: CreateResultQRCodeViewModel(navigationSender: PassthroughSubject<ResultEventFlow, Never>(), communicationBus: PassthroughSubject<ResultEventBus, Never>(), localStorage: CoreDataManager.shared, qrCodeFormat: .telegram, qrCodeString: "tetet"))
}
