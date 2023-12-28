//
//  StyleConfig.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import UIKit

struct StyleConfig {
    static var settingsNavBarAppearance: UINavigationBarAppearance {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .primaryApp
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        return coloredAppearance
    }
    
    static var mainNavBarAppearance: UINavigationBarAppearance {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .white
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        coloredAppearance.shadowImage = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).shadowImageNavigationBar()
        return coloredAppearance
    }
}
