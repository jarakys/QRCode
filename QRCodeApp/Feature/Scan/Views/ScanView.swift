//
//  ScanView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI
import PhotosUI
import Combine

struct ScanView: View {
    @StateObject public var viewModel: ScanViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State var device = AVCaptureDevice.default(for: .video)
    var body: some View {
        VStack(spacing: 0) {
            Text("Ad block")
                .frame(maxWidth: .infinity)
                .frame(height: 100)
            ZStack {
                QRCodeScanner(callback: { string in
                    viewModel.setRecognized(string: string)
                })
                VStack {
                    Text("Place QR code or Barcode in frame")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.titleScan)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    
                    Image(.scanFrameIcon)
                        .frame(width: 166, height: 166)
                    Spacer()
                    HStack(spacing: 16) {
                        Button(action: {
                            viewModel.splashDidTap()
                            //TODO: Flash
                        }, label: {
                            Image(!viewModel.isFlashOn ? .splashIcon : .splashOffIcon)
                        })
                        
                        PhotosPicker(selection: $selectedItem,
                                     matching: .images,
                                     label: {
                            
                            Image(.galleryIcon)
                            
                        })
                    }
                    .padding(.all, 8)
                    .background(.white.opacity(0.6))
                    .cornerRadius(10)
                }
                .padding(.vertical, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.white, for: .tabBar)
        .onReceive(viewModel.$isFlashOn, perform: { value in
            try? device?.lockForConfiguration()
            device?.torchMode = value ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
            device?.unlockForConfiguration()
        })
        .onReceive(viewModel.eventSender, perform: { event in
            switch event {
            case .vibrate:
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        })
        .onChange(of: selectedItem) { item in
            item?.loadTransferable(type: Data.self, completionHandler: { item in
                switch item {
                case .success(let success):
                    guard let success else { return }
                    DispatchQueue.main.async {
                        viewModel.detect(on: success)
                        selectedItem = nil
                    }
                    
                case .failure(let failure):
                    print("error \(failure)")
                }
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Scan")
    }
}

#Preview {
    ScanView(viewModel: ScanViewModel(navigationSender: PassthroughSubject<ScanEventFlow, Never>()))
}
