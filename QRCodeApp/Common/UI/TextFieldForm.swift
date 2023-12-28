//
//  TextFieldForm.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import SwiftUI

struct TextFieldForm: View {
    public let items: [TextViewModel]
    public var padding = 32
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 32)
            VStack(spacing: 16) {
                ForEach(items, id: \.title) { item in
                    TitledTextField(title: item.title, placeholder: item.placeholder, example: item.example, text: .init(get: {
                        item.text
                    }, set: { text in
                        item.text = text
                    }))
                }
            }
        }
    }
}
