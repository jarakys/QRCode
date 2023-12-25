//
//  DesignElements.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 23.12.2023.
//

import Foundation

enum DesignElements: Hashable, DesignIconProtocol {
    case squareBody
    case roundedBody
    case circleBody
    
    case squareMarker
    case roundedMarker
    case leafMarker
    case circleMarker
    case roundedPointingInMarker
    
    case logo(image: String)
    
    private var iconName: String {
        switch self {
        case .circleBody:
            return "circleBody"
            
        case .squareBody:
            return "circleBody"
            
        case .roundedBody:
            return "roundedBody"
            
        case .leafMarker:
            return "leafMarker"
            
        case .circleMarker:
            return "circleMarker"
            
        case .squareMarker:
            return "squareMarker"
            
        case .roundedMarker:
            return "roundedMarker"
            
        case .roundedPointingInMarker:
            return "roundedPointingInMarker"
            
        case .logo:
            return ""
           
        }
    }
    
    var designIcon: String {
        switch self {
        case let .logo(image):
            return image
            
        default:  return "\(iconName)Icon"
        }
    }
}
