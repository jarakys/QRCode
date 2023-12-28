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
    
    case colorMaskBackground(color: String)
    case colorMaskLeaf
    case colorMaskPixels
    case colorMaskEye
    
    private var iconName: String {
        switch self {
        case .circleBody:
            return "circleBody"
            
        case .squareBody:
            return "squareBody"
            
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
            
        case .colorMaskBackground:
            return "colorMaskBackground"
            
        case .colorMaskLeaf:
            return "colorMaskLeaf"
            
        case .colorMaskPixels:
            return "colorMaskPixels"
            
        case .colorMaskEye:
            return "colorMaskEye"
            
        case .logo:
            return ""
           
        }
    }
    
    var color: String? {
        switch self {
        case let .colorMaskBackground(color):
            return color
            
        default: return nil
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
