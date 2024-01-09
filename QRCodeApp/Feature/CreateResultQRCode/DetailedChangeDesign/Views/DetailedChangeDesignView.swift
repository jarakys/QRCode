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
                            .shadow(color: Color(red: 0, green: 0.3294, blue: 0.4902, opacity: 0.1016),
                                                radius: 9.656891822814941,
                                                x: 3.218963861465454,
                                                y: 3.218963861465454)
                    }
                    
                case .colorMaskLeaf:
                    ZStack {
                        ColorPicker("", selection: $viewModel.leftColor)
                            .scaleEffect(2)
                            .padding(.trailing, 20)
                        DetailedChangeDesignCellView(model: model)
                            .allowsHitTesting(false)
                            .disabled(true)
                            .shadow(color: Color(red: 0, green: 0.3294, blue: 0.4902, opacity: 0.1016),
                                                radius: 9.656891822814941,
                                                x: 3.218963861465454,
                                                y: 3.218963861465454)
                    }
                    
                case .colorMaskPixels:
                    ZStack {
                        ColorPicker("", selection: $viewModel.pixelColor)
                            .scaleEffect(2)
                            .padding(.trailing, 20)
                        DetailedChangeDesignCellView(model: model)
                            .allowsHitTesting(false)
                            .disabled(true)
                            .shadow(color: Color(red: 0, green: 0.3294, blue: 0.4902, opacity: 0.1016),
                                                radius: 9.656891822814941,
                                                x: 3.218963861465454,
                                                y: 3.218963861465454)
                    }
                    
                case .colorMaskBackground:
                    ZStack {
                        ColorPicker("", selection: $viewModel.backgroundColor)
                            .scaleEffect(2)
                            .padding(.trailing, 20)
                        DetailedChangeDesignCellView(model: model)
                            .allowsHitTesting(false)
                            .disabled(true)
                            .shadow(color: Color(red: 0, green: 0.3294, blue: 0.4902, opacity: 0.1016),
                                                radius: 9.656891822814941,
                                                x: 3.218963861465454,
                                                y: 3.218963861465454)
                    }
                    
                default: DetailedChangeDesignCellView(model: model)
                        .shadow(color: Color(red: 0, green: 0.3294, blue: 0.4902, opacity: 0.1016),
                                            radius: 9.656891822814941,
                                            x: 3.218963861465454,
                                            y: 3.218963861465454)
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
        .fullScreenCover(isPresented: $viewModel.showSheet, content: {
            PaywallView(shouldStartSession: false, shouldRequestAd: false)
        })
    }
}
