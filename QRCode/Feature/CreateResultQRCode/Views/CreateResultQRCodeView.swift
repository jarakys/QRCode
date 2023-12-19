//
//  CreateResultQRCodeView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import SwiftUI
//import QRCodeGenerator

final class CreateResultQRCodeViewModel: ObservableObject {
    private let qrCodeFormat: QRCodeFormat
    
    public lazy var title: String = { [unowned self] in
        "QRCode · \(self.qrCodeFormat.format)"
    }()
    
    init(qrCodeFormat: QRCodeFormat) {
        self.qrCodeFormat = qrCodeFormat
    }
}

struct CreateResultQRCodeView: View {
    @StateObject public var viewModel: CreateResultQRCodeViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.createResultTitle)
        }
    }
}

#Preview {
    CreateResultQRCodeView(viewModel: CreateResultQRCodeViewModel(qrCodeFormat: .telegram))
}
