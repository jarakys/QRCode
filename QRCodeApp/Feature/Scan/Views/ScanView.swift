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
    @State var audioPlayer: AVAudioPlayer?
    @State var device = AVCaptureDevice.default(for: .video)
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack {
                    if !viewModel.isPremium {
                        AdMobBannerView(adUnitId: "ca-app-pub-4295606907432979/5196526328")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .padding(.all, 2)
                            .background(.clear)
                            .zIndex(2)
                    }
                    Text("Place QR code or Barcode in frame")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.titleScan)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .zIndex(2)
                QRCodeScanner(callback: { string in
                    viewModel.setRecognized(string: string)
                })
                .background(.black)
                VStack {
                    Spacer()
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
        .onReceive(viewModel.$isFlashOn, perform: { value in
            try? device?.lockForConfiguration()
            device?.torchMode = value ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
            device?.unlockForConfiguration()
        })
        .onReceive(viewModel.eventSender, perform: { event in
            switch event {
            case .vibrate:
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            case .sound:
                playSound()
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
        .fullScreenCover(isPresented: $viewModel.showPremium, content: {
            PaywallView(shouldStartSession: true, shouldRequestAd: false)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Scan")
    }
    
    private func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "antic", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error loading sound file: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ScanView(viewModel: ScanViewModel(navigationSender: PassthroughSubject<ScanEventFlow, Never>()))
}
