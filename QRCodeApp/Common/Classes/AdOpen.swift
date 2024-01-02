//
//  AdOpen.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 02.01.2024.
//

import Foundation
import GoogleMobileAds

final class OpenAd: NSObject, GADFullScreenContentDelegate {
   var appOpenAd: GADAppOpenAd?
   var loadTime = Date()
    
    
    func requestAppOpenAd(completion: (() -> Void)?) {
        let request = GADRequest()
        GADAppOpenAd.load(withAdUnitID: "ca-app-pub-3940256099942544/9257395921",
                          request: request,
                          orientation: UIInterfaceOrientation.portrait,
                          completionHandler: { (appOpenAdIn, _) in
            self.appOpenAd = appOpenAdIn
            self.appOpenAd!.fullScreenContentDelegate = self
            self.loadTime = Date()
            completion?()
        })
    }
    
   func tryToPresentAd() {
       guard let fromRootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
       if let gOpenAd = self.appOpenAd, wasLoadTimeLessThanNHoursAgo(thresholdN: 4) {
           gOpenAd.present(fromRootViewController: fromRootViewController)
       } else {
           self.requestAppOpenAd(completion: { [weak self] in
               self?.tryToPresentAd()
           })
       }
   }
   
   func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
       let now = Date()
       let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(self.loadTime)
       let secondsPerHour = 3600.0
       let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
       return intervalInHours < Double(thresholdN)
   }
   
   func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
       print("[OPEN AD] Failed: \(error)")
       requestAppOpenAd(completion: nil)
   }
   
   func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       requestAppOpenAd(completion: nil)
       print("[OPEN AD] Ad dismissed")
   }
}
