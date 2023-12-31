//
//  QRCodeFormat.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation

public enum QRCodeFormat: String, CaseIterable {
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
    
    public var openIn: String? {
        switch self {
        case .phone:
            return String(localized: "Contacts")
            
        case .email:
            return description
            
        case .sms:
            return description
            
        case .url:
            return String(localized: "Safari")
            
        case .text:
            return nil
            
        case .wifi:
            return description
            
        case .location:
            return String(localized: "Maps")
            
        case .telegram:
            return description
            
        case .facebook:
            return description
            
        case .instagram:
            return description
            
        case .twitter:
            return description
            
        case .whatsApp:
            return description
            
        case .tikTok:
            return description
            
        case .spotify:
            return description
            
        case .snapchat:
            return description
        }
    }
    
    public var regexPattern: String {
        switch self {
        case .phone:
            return "tel:"
            
        case .url:
            return "url:"
            
        case .text:
            return ""
            
        case .sms:
            return "smsto"
            
        case .wifi:
            return "WIFI:"
            
        case .email:
            return "mailto"
            
        case .location:
            return "geo"
            
        case .telegram:
            return "https://t\\.me/.*"
        
        case .facebook:
            return "https://www.facebook.com/"
            
        case .instagram:
            return "https://www.instagram.com/"
            
        case .twitter:
            return "https://twitter.com/"
            
        case .whatsApp:
            return "https://wame/qr/"
            
        case .tikTok:
            return "https://www.tiktok.com/"
            
        case .spotify:
            return "https://open.spotify.com/"
            
        case .snapchat:
            return "https://snapchat.com/"
        }
    }
    
    public var regexExtract: [String] {
        switch self {
        case .phone:
            return [#"tel:\s?(\S+)"#]
            
        case .url:
            return [#"url:\s?(\S+)"#]
            
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
            return "WIFI:S:%@;T:%@;P:%@;H:%@;;"
            
        case .url:
            return "url:%@"
            
        case .text, .facebook, .twitter, .tikTok, .snapchat, .telegram, .whatsApp, .spotify, .instagram:
            return "%@"
            
        case .sms:
            return "smsto:%@:%@"
            
        case .email:
            return "mailto:%@?cc=%@&body=%@"
            
        case .location:
            return "geo:%@,%@"
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
