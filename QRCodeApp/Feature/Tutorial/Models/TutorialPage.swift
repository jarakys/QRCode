//
//  TutorialPage.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 30.12.2023.
//

import Foundation

enum TutorialPage: String {
    case intro
    case designedFor
    
    var id: Int {
        switch self {
        case .intro:
            return 0
            
        case .designedFor:
            return 1
        }
    }
    
    var title: String {
        switch self {
        case .intro:
            return String(localized: "Help us improve QR code reader & scanner")
        case .designedFor:
            return String(localized: "Equipped with a myriad of user-friendly features")
        }
    }
    
    var description: String {
        switch self {
        case .intro:
            return String(localized: """
By opting to "Allow tracking," you play a key role in enhancing the app experience, benefiting not only yourself but all users.

Your choice will simplify the enjoyment of our app for others, and you can take pride in being a part of this positive influence
""")
        case .designedFor:
            return String(localized: "QR code reader & scanner (app name) is designed to cater to all your scanning and QR creation requirements.")
        }
    }
    
    var image: String {
        return "\(self.rawValue)Icon"
    }
}
