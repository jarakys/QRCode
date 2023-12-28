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
