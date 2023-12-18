//
//  QRCodeFormat.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation

public enum QRCodeFormat {
    case phone
    case email
    case sms
    case url
    case text
    case wifi
    case location
    case telegram
    case facebook
    case instagram
    case twitter
    case whatsApp
    case tikTok
    case spotify
    case snapchat
    
    public var description: String {
        switch self {
        case .phone:
            return "Phone"
            
        case .email:
            return "Email"
            
        case .sms:
            return "SMS"
            
        case .url:
            return "URL"
            
        case .text:
            return "Text"
            
        case .wifi:
            return "WIFI"
            
        case .location:
            return "Location"
            
        case .telegram:
            return "Telegram"
            
        case .facebook:
            return "Facebook"
            
        case .instagram:
            return "Instagram"
            
        case .twitter:
            return "Twitter"
            
        case .whatsApp:
            return "WhatsApp"
            
        case .tikTok:
            
            return "Tik Tok"
            
        case .spotify:
            return "Spotify"
            
        case .snapchat:
            return "Snapchat"
        }
    }
    
    public var format: String {
        switch self {
        case .phone:
            return "tel:"
        
        case .wifi:
            return "WIFI:S:pocketables;P:let there be cake;;"
            
        case .url:
            return "url:"
            
        default: return ""
        }
    }
    
    var image: String {
        switch self {
        case .phone: return "phoneIcon"
        
        case .sms: return "smsIcon"
            
        case .email: return "emailIcon"
            
        case .url: return "urlIcon"
            
        default: return ""
        }
    }
}
