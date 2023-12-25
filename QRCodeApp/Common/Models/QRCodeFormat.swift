//
//  QRCodeFormat.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation

public enum QRCodeFormat: CaseIterable {
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
            return String(localized: "Phone")
            
        case .email:
            return String(localized: "Email")
            
        case .sms:
            return String(localized: "SMS")
            
        case .url:
            return String(localized: "URL")
            
        case .text:
            return String(localized: "Text")
            
        case .wifi:
            return String(localized: "WIFI")
            
        case .location:
            return String(localized: "Location")
            
        case .telegram:
            return String(localized: "Telegram")
            
        case .facebook:
            return String(localized: "Facebook")
            
        case .instagram:
            return String(localized: "Instagram")
            
        case .twitter:
            return String(localized: "Twitter")
            
        case .whatsApp:
            return String(localized: "WhatsApp")
            
        case .tikTok:
            return String(localized: "Tik Tok")
            
        case .spotify:
            return String(localized: "Spotify")
            
        case .snapchat:
            return String(localized: "Snapchat")
        }
    }
    
    public var regexPattern: String {
        switch self {
        case .phone:
            return "tel: [0-9]+$"
            
        case .url:
            return "url: .+$"
            
        case .text:
            return ""
            
        case .sms:
            return "smsto"
            
        case .wifi:
            return "WIFI:S:[^;]+;P:[^;]+;$"
            
        case .email:
            return "mailto"
            
        
        default: return ""
        }
    }
    
    public var regexExtract: [String] {
        switch self {
        case .phone:
            return [#"tel:\s?(\d+)"#]
            
        case .url:
            return [#"tel:\s?(\d+)"#]
            
        case .text:
            return [""]
            
        case .sms:
            return [#"smsto:(\d+):"#, #":(.*)"#]
            
        case .wifi:
            return [#"WIFI:S:(.*?);"#, #"P:(.*?);"#]
            
        case .email:
            return [#"mailto:([^\?]+)"#, #"cc=([^&]+)"#, #"body=([^&]+)"#]
        
        default: return [""]
        }
    }
    
    public var format: String {
        switch self {
        case .phone:
            return "tel:%@"
        
        case .wifi:
            return "WIFI:S:%@;P:%@;;"
            
        case .url:
            return "url:%@"
            
        case .text:
            return "%@"
            
        case .sms:
            return "smsto:%@:%@"
            
        case .email:
            return "mailto:%@?cc=%@&body=%@"
            
        default: return ""
        }
    }
    
    var image: String {
        switch self {
        case .phone: return "phoneIcon"
        
        case .sms: return "smsIcon"
            
        case .email: return "emailIcon"
            
        case .url: return "urlIcon"
            
        case .facebook: return "facebookIcon"
            
        case .instagram: return "instagramIcon"
            
        case .location: return "locationIcon"
            
        case .snapchat: return "snapchatIcon"
            
        case .spotify: return "spotifyIcon"
            
        case .telegram: return "telegramIcon"
            
        case .text: return "textIcon"
            
        case .tikTok: return "tikTokIcon"
            
        case .twitter: return "twitterIcon"
            
        case .wifi: return "wifiIcon"
            
        case .whatsApp: return "whatsAppIcon"
        }
    }
}
