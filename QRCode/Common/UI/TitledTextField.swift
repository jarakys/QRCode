//
//  TitledTextField.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import SwiftUI

struct TitledTextField: View {
    public let title: String
    public let placeholder: String
    public let example: String?
    @Binding public var text: String
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .foregroundStyle(.titleTextField)
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                TextField(placeholder, text: $text, axis: .vertical)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
            }
            .background(.white)
            .cornerRadius(10)
            if let example {
                Text(example)
                    .foregroundStyle(.secondaryTextField)
                    .font(.system(size: 11))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TitledTextField(title: "Hi", placeholder: "", example: nil, text: .constant("Kirill"))
}
