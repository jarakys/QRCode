//
//  DetailedChangeDesignView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import SwiftUI
import QRCode
import CompositionalList
import Combine

final class DetailedChangeDesignViewModel: ObservableObject {
    @Published public var items: [DetailedChangeDesignSectionModel]
//    @Published public var selectedBody: DesignElementViewModel!
//    @Published public var selectedMarker: DesignElementViewModel
//    @Published public var
    
    private let navigationSender: PassthroughSubject<ResultEventFlow, Never>
    private let communicationBus: PassthroughSubject<ResultEventBus, Never>
    private let qrCodeString: String
    private let qrCodeDesign: QRCodeDesign
    
    private var selectedBody: DesignElementViewModel
    private var selectedMarker: DesignElementViewModel
    private var selectedLogo: DesignElementViewModel?
    
    public lazy var qrDocument: QRCode.Document = { [unowned self] in
        let qrCodeDocument = QRCode.Document(generator: QRCodeGenerator_External())
        qrCodeDocument.utf8String = qrCodeString
        qrCodeDocument.design = qrCodeDesign.qrCodeDesign
        qrCodeDocument.logoTemplate = qrCodeDesign.logo
        return qrCodeDocument
    }()
    
    init(qrCodeString: String,
         qrCodeDesign: QRCodeDesign,
         navigationSender: PassthroughSubject<ResultEventFlow, Never>,
         communicationBus: PassthroughSubject<ResultEventBus, Never>) {
        self.navigationSender = navigationSender
        self.communicationBus = communicationBus
        self.qrCodeString = qrCodeString
        self.qrCodeDesign = qrCodeDesign
        
        selectedBody = DesignElementViewModel(isSelected: true, item: .squareBody)
        selectedMarker = DesignElementViewModel(isSelected: true, item: .squareMarker)
        
        items = [
            DetailedChangeDesignSectionModel(sectionIdentifier: .body,
                                             cellIdentifiers:
                                                [
                                                    selectedBody,
                                                    DesignElementViewModel(isSelected: false, item: .roundedBody),
                                                    DesignElementViewModel(isSelected: false, item: .circleBody)
                                                ]),
            DetailedChangeDesignSectionModel(sectionIdentifier: .marker,
                                             cellIdentifiers:
                                                [
                                                    selectedMarker,
                                                    DesignElementViewModel(isSelected: false, item: .roundedMarker),
                                                    DesignElementViewModel(isSelected: false, item: .circleMarker),
//                                                    DesignElementViewModel(isSelected: false, item: .leafMarker),
                                                    DesignElementViewModel(isSelected: false, item: .roundedPointingInMarker)
                                                ]),
            DetailedChangeDesignSectionModel(sectionIdentifier: .logoMask,
                                             cellIdentifiers:
                                                [
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "forkLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "twitterLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "phoneLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "tikTokLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "wifiLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "spotifyLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "youTubeLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "facebookLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "telegramLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "giftLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "heartLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "creditCardLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "locationLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "addLogoIcon"))
                                                ]),
            DetailedChangeDesignSectionModel(sectionIdentifier: .color,
                                             cellIdentifiers:
                                                [
                                                    DesignElementViewModel(isSelected: false, item: .colorMaskBackground(color: "ColorBackgroundColor")),
                                                    DesignElementViewModel(isSelected: false, item: .colorMaskLeaf),
                                                    DesignElementViewModel(isSelected: false, item: .colorMaskPixels),
                                                    DesignElementViewModel(isSelected: false, item: .colorMaskEye)
                                                ])
        ]
        
    }
    
    public func didClick(on item: DesignElementViewModel) {
        switch item.item {
        case .circleBody, .squareBody, .roundedBody:
            selectBody(item: item)
            
        case .leafMarker, .circleMarker, .squareMarker, .roundedMarker, .roundedPointingInMarker:
            selectMarker(item: item)
            
        case .logo:
            selectLogo(item: item)
            
        case .colorMaskEye, .colorMaskLeaf, .colorMaskPixels, .colorMaskBackground:
            break
        }
    }
    
    private func selectBody(item: DesignElementViewModel) {
        selectedBody.isSelected = false
        selectedBody = item
        selectedBody.isSelected = true
    }
    
    private func selectMarker(item: DesignElementViewModel) {
        selectedMarker.isSelected = false
        selectedMarker = item
        selectedMarker.isSelected = true
    }
    
    private func selectLogo(item: DesignElementViewModel) {
        guard selectedLogo?.item != item.item else {
            selectedLogo?.isSelected = false
            selectedLogo = nil
            return
        }
        selectedLogo?.isSelected = false
        selectedLogo = item
        selectedLogo?.isSelected = true
    }
    
    public func save() {
        
    }
    
    public func cancel() {
        navigationSender.send(.back)
    }
}

struct DetailedChangeDesignView: View {
    @StateObject public var viewModel: DetailedChangeDesignViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            QRCodeDocumentUIView(document: viewModel.qrDocument)
                .frame(width: 240, height: 240)
                .padding(.top, 16)
            CompositionalList(viewModel.items) { model, indexPath in
                DetailedChangeDesignCellView(model: model)
            }.sectionHeader { sectionIdentifier, kind, indexPath in
                Text(sectionIdentifier.description)
                    .font(.system(size: 15))
                    .foregroundStyle(.cellTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, -12)
            }
            .selectedItem { item in
                viewModel.didClick(on: item)
            }
            .customLayout(.composed())
            .padding(.horizontal, 8)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Templates")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        viewModel.save()
                    }, label: {
                        Text("Save")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.tint)
                    })
                })
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button("Cancel", action: {
                        viewModel.cancel()
                    })
                    .foregroundStyle(.tint)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.tint)
                })
            })
        }
        .background(.secondaryBackground)
    }
}
