//
//  BannerView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 31.12.2023.
//

import SwiftUI
import GoogleMobileAds

struct AdMobBannerView: UIViewControllerRepresentable {

    private var adUnitId: String

    public init(adUnitId: String) {
        self.adUnitId = adUnitId
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        view.backgroundColor = .colorBackground
        
        view.backgroundColor = UIColor.white
        let customView = UIView()
        customView.backgroundColor = UIColor.white
        
        let viewController = UIViewController()
        view.adUnitID = self.adUnitId
        view.rootViewController = viewController
        customView.addSubview(view)
        viewController.view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        customView.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct BigAdMobBannerView: UIViewControllerRepresentable {

    private var adUnitId: String

    public init(adUnitId: String) {
        self.adUnitId = adUnitId
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADAdSizeMediumRectangle)
        view.backgroundColor = .colorBackground
        
        view.backgroundColor = UIColor.white
        let customView = UIView()
        customView.backgroundColor = UIColor.white
        
        let viewController = UIViewController()
        view.adUnitID = self.adUnitId
        view.rootViewController = viewController
        customView.addSubview(view)
        viewController.view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        customView.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
