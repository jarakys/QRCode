//
//  ShareActivityManager.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import UIKit

struct ShareItemModel<T> {
    let item: T
    let title: String
}

class ShareActivityManager {
    static func share(images: [ShareItemModel<UIImage?>]) {
        let any: [Any] = images.map({ [$0.title, $0.item] }).flatMap({ $0 })
        let activityVC = UIActivityViewController(activityItems: any, applicationActivities: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    static func share(datas: [ShareItemModel<Data>]) {
        let uiImages = datas.map({ ShareItemModel(item: UIImage(data: $0.item), title: $0.title)  })
        share(images: uiImages)
    }
}
