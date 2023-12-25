//
//  ChangeDesignView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import SwiftUI
import Combine
import CompositionalList
import QRCode

final class DetailedChangeDesignViewModel: ObservableObject {
    @Published public var items: [DetailedChangeDesignSectionModel]
//    @Published public var selectedBody: DesignElementViewModel!
//    @Published public var selectedMarker: DesignElementViewModel
//    @Published public var
    
    private let navigationSender: PassthroughSubject<ResultEventFlow, Never>
    private let communicationBus: PassthroughSubject<ResultEventBus, Never>
    private let qrCodeString: String
    private let qrCodeDesign: QRCodeDesign
    
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
        
        items = [
            DetailedChangeDesignSectionModel(sectionIdentifier: .body,
                                             cellIdentifiers: 
                                                [
                                                    DesignElementViewModel(isSelected: true, item: .squareBody),
                                                    DesignElementViewModel(isSelected: false, item: .roundedBody),
                                                    DesignElementViewModel(isSelected: false, item: .circleBody)
                                                ]),
            DetailedChangeDesignSectionModel(sectionIdentifier: .marker,
                                             cellIdentifiers:
                                                [
                                                    DesignElementViewModel(isSelected: true, item: .squareMarker),
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
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "hearLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "creditCardLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "locationLogoIcon")),
                                                    DesignElementViewModel(isSelected: false, item: .logo(image: "addLogoIcon"))
                                                ])
        ]
    }
    
    public func didClick(on item: DesignElementViewModel) {
        
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
            CompositionalList(viewModel.items) { model, indexPath in
                DesignCellView(model: model)
            }.sectionHeader { sectionIdentifier, kind, indexPath in
                Text(sectionIdentifier.description)
            }
            .selectedItem { item in
                viewModel.didClick(on: item)
            }
            .customLayout(.composed())
        }
        .background(.secondaryBackground)
    }
}

struct ChangeDesignView: View {
    @StateObject public var viewModel: ChangeDesignViewModel
    
    var body: some View {
        CompositionalList(viewModel.items) { model, indexPath in
            DesignCellView(model: model)
        }.sectionHeader { sectionIdentifier, kind, indexPath in
            EmptyView()
        }
        .selectedItem { item in
            viewModel.didClick(on: item)
        }
        .customLayout(.designChanged(sections: [1]))
        .background(.secondaryBackground)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button("Cancel", action: {
                    viewModel.cancel()
                })
                .foregroundStyle(.tint)
                    
            })
            ToolbarItem(placement: .principal, content: {
                Text("Templates")
                    .font(.system(size: 17, weight: .semibold))
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button("Save", action: {
                    viewModel.save()
                })
                .fontWeight(.semibold)
                .foregroundStyle(.tint)
            })
        })
    }
}

#Preview {
    ChangeDesignView(viewModel: ChangeDesignViewModel(navigationSender: PassthroughSubject<ResultEventFlow, Never>(), communicationBus: PassthroughSubject<ResultEventBus, Never>()))
}
