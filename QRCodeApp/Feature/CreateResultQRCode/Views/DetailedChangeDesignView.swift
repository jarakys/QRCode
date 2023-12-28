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

final class DetailedChangeDesignViewModel: BaseViewModel {
    @Published public var items: [DetailedChangeDesignSectionModel]
    
    private let navigationSender: PassthroughSubject<ResultEventFlow, Never>
    private let communicationBus: PassthroughSubject<ResultEventBus, Never>
    private let qrCodeString: String
    private let qrCodeDesign: QRCodeDesign
    
    @Published public var eyeColor: Color = .qrCodeDefault
    @Published public var leftColor: Color = .qrCodeDefault
    @Published public var pixelColor: Color = .qrCodeDefault
    @Published public var backgroundColor: Color = .qrCodeDefault
    
    private var selectedBody: DesignElementViewModel
    private var selectedMarker: DesignElementViewModel
    public var selectedLogo: DesignElementViewModel?
    
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
        
        selectedBody = DesignElementViewModel(isSelected: qrCodeDesign == .default, item: .squareBody)
        selectedMarker = DesignElementViewModel(isSelected: qrCodeDesign == .default, item: .squareMarker)
        
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
    
    override func bind() {
        $eyeColor.sink(receiveValue: { [weak self] color in
            guard let self else { return }
            let cgColor = UIColor(color).cgColor
            self.qrDocument.design.style.pupil = QRCode.FillStyle.Solid(cgColor)
            self.qrDocument.setHasChanged()
        }).store(in: &cancellable)
        
        $leftColor.sink(receiveValue: { [weak self] color in
            guard let self else { return }
            let cgColor = UIColor(color).cgColor
            self.qrDocument.design.style.eye = QRCode.FillStyle.Solid(cgColor)
            self.qrDocument.setHasChanged()
        }).store(in: &cancellable)
        
        $pixelColor.sink(receiveValue: { [weak self] color in
            guard let self else { return }
            let cgColor = UIColor(color).cgColor
            self.qrDocument.design.style.onPixels = QRCode.FillStyle.Solid(cgColor)
            self.qrDocument.setHasChanged()
        }).store(in: &cancellable)
        
        $backgroundColor.sink(receiveValue: { [weak self] color in
            guard let self else { return }
            let cgColor = UIColor(color).cgColor
            self.qrDocument.design.style.background = QRCode.FillStyle.Solid(cgColor)
            self.qrDocument.setHasChanged()
        }).store(in: &cancellable)
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
        qrDocument.setHasChanged()
    }
    
    private func selectBody(item: DesignElementViewModel) {
        selectedBody.isSelected = false
        selectedBody = item
        selectedBody.isSelected = true
        
        applyBody(item: item.item)
    }
    
    private func selectMarker(item: DesignElementViewModel) {
        selectedMarker.isSelected = false
        selectedMarker = item
        selectedMarker.isSelected = true
        
        applyMarker(item: item.item)
    }
    
    private func selectLogo(item: DesignElementViewModel) {
        defer {
            applyLogo(item: selectedLogo?.item)
        }
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
    
    private func applyBody(item: DesignElements) {
        switch item {
        case .circleBody:
            qrDocument.design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.3)
            
        case .squareBody:
            qrDocument.design.shape.onPixels = QRCode.PixelShape.Square()
            
        case .roundedBody:
            qrDocument.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.8)
            
        default: break
        }
    }
    
    private func applyMarker(item: DesignElements) {
        switch item {
        case .leafMarker:
            qrDocument.design.shape.eye = QRCode.EyeShape.Leaf()
            
        case .circleMarker:
            qrDocument.design.shape.eye = QRCode.EyeShape.Circle()
            
        case .squareMarker:
            qrDocument.design.shape.eye = QRCode.EyeShape.Square()
            
        case .roundedMarker:
            qrDocument.design.shape.eye = QRCode.EyeShape.RoundedRect()
        
        case .roundedPointingInMarker:
            qrDocument.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()
            
        default:
            break
        }
    }
    
    private func applyLogo(item: DesignElements?) {
        guard let item else {
            qrDocument.logoTemplate = nil
            return
        }
        let icon = item.designIcon
        guard let cgImage = UIImage(named: icon)?.cgImage else { return }
        qrDocument.logoTemplate = QRCode.LogoTemplate.CircleCenter(image: cgImage, inset: 10)
    }
}

struct DetailedChangeDesignView: View {
    @StateObject public var viewModel: DetailedChangeDesignViewModel
    @State public var color: Color = .green
    
    var body: some View {
        VStack(spacing: 25) {
            QRCodeDocumentUIView(document: viewModel.qrDocument)
                .frame(width: 240, height: 240)
                .padding(.top, 16)
            CompositionalList(viewModel.items) { model, indexPath in
                switch model.item {
                case .colorMaskEye:
                    ZStack {
                        ColorPicker("", selection: $viewModel.eyeColor)
                            .scaleEffect(2)
                            .padding(.trailing, 20)
                        DetailedChangeDesignCellView(model: model)
                            .allowsHitTesting(false)
                            .disabled(true)
                    }
                    
                case .colorMaskLeaf:
                    ZStack {
                        ColorPicker("", selection: $viewModel.leftColor)
                            .scaleEffect(2)
                            .padding(.trailing, 20)
                        DetailedChangeDesignCellView(model: model)
                            .allowsHitTesting(false)
                            .disabled(true)
                    }
                    
                case .colorMaskPixels:
                    ZStack {
                        ColorPicker("", selection: $viewModel.pixelColor)
                            .scaleEffect(2)
                            .padding(.trailing, 20)
                        DetailedChangeDesignCellView(model: model)
                            .allowsHitTesting(false)
                            .disabled(true)
                    }
                    
                case .colorMaskBackground:
                    ZStack {
                        ColorPicker("", selection: $viewModel.backgroundColor)
                            .scaleEffect(2)
                            .padding(.trailing, 20)
                        DetailedChangeDesignCellView(model: model)
                            .allowsHitTesting(false)
                            .disabled(true)
                    }
                    
                default: DetailedChangeDesignCellView(model: model)
                }
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
