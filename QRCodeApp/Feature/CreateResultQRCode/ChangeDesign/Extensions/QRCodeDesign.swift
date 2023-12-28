//
//  QRCodeDesign.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import QRCode

protocol DesignIconProtocol {
    var designIcon: String { get }
    var color: String? { get }
}

enum QRCodeDesign: String, CaseIterable, DesignIconProtocol {
    case `default`
    case twitter
    case facebook
    case spotify
    case telegram
    case tikTok
    case email
    case location
    case phone
    case email2
    case wifi
    case snapchat
    case phone2
    case heart
    case circle
    
    var designIcon: String {
        "\(self.rawValue)DesignIcon"
    }
    
    var color: String? {
        nil
    }
    
    var qrCodeDesign: QRCode.Design {
        switch self {
        case .`default`:
            return .default()
            
        case .twitter:
            return .twitter()
            
        case .facebook:
            return .facebook()
            
        case .spotify:
            return .spotify()
            
        case .telegram:
            return .telegram()
            
        case .tikTok:
            return .tikTok()
            
        case .email:
            return .email()
            
        case .location:
            return .location()
            
        case .phone:
            return .phone()
            
        case .email2:
            return .email1()
            
        case .wifi:
            return .wifi()
            
        case .snapchat:
            return .snapchat()
            
        case .phone2:
            return .phone1()
            
        case .heart:
            return .heart()
            
        case .circle:
            return .default()
        }
    }
    
    var logo: QRCode.LogoTemplate? {
        switch self {
        case .`default`:
            return nil
            
        case .twitter:
            return .twitter()
            
        case .facebook:
            return .facebook()
            
        case .spotify:
            return .spotify()
            
        case .telegram:
            return .telegram()
            
        case .tikTok:
            return .tikTok()
            
        case .email:
            return .email()
            
        case .location:
            return .location()
            
        case .phone:
            return .phone()
            
        case .email2:
            return .email1()
            
        case .wifi:
            return .wifi()
            
        case .snapchat:
            return .snapchat()
            
        case .phone2:
            return .phone1()
            
        case .heart:
            return .heart()
            
        case .circle:
            return nil
        }
    }
}
