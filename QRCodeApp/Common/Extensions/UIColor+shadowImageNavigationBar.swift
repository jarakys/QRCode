//
//  UIColor+shadowImageNavigationBar.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import UIKit

extension UIColor {
    func shadowImageNavigationBar() -> UIImage {
        UIGraphicsBeginImageContext(CGSizeMake(1, 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
