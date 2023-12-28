//
//  ShareActivityManager.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import UIKit

class ShareActivityManager {
    static func share(images: [UIImage?]) {
        let myShare = "QRCode"
        let any: [Any] = [myShare] as Array<Any> + images as Array<Any>
        let activityVC = UIActivityViewController(activityItems: any, applicationActivities: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    static func share(datas: [Data]) {
        let uiImages = datas.map({ UIImage(data: $0) })
        share(images: uiImages)
    }
}
