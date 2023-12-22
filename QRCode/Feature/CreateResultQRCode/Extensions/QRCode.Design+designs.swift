//
//  QRCode.Design+designs.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import UIKit
import QRCode

extension QRCode.LogoTemplate {
    static func twitter() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.twitterDesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func facebook() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.facebookDesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func spotify() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.spotifyDesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func telegram() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.telegramDesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func tikTok() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.tikTokDesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func email() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.emailDesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func location() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.locationDesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func phone() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.phoneDesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func email1() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.email2DesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func wifi() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.wifiDesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func snapchat() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.snapchatDesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func phone1() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.phone2DesignMaskIcon).cgImage!, inset: 10)
    }
    
    static func heart() -> QRCode.LogoTemplate {
        QRCode.LogoTemplate.CircleCenter(image: UIImage(resource: ImageResource.heartDesignMaskIcon).cgImage!, inset: 10)
    }
}

extension QRCode.Design {
    private static func base() -> QRCode.Design {
        let design = QRCode.Design()
        design.shape.eye = QRCode.EyeShape.Square()
        design.shape.onPixels = QRCode.PixelShape.Square()
        design.style.onPixels = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeDefault).cgColor)
        design.shape.offPixels = QRCode.PixelShape.Square()
        design.style.offPixels = QRCode.FillStyle.Solid(UIColor.clear.cgColor)
        design.additionalQuietZonePixels = 1
        design.style.backgroundFractionalCornerRadius = 2
        return design
    }
    static func `default`() -> QRCode.Design {
        let design = base()
        return design
    }
    
    static func twitter() -> QRCode.Design {
        let design = base()
        design.style.onPixels = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeTwitter).cgColor)
        return design
    }
    
    static func facebook() -> QRCode.Design {
        let design = base()
        design.style.onPixels = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeFacebook).cgColor)
        return design
    }
    
    static func spotify() -> QRCode.Design {
        let design = base()
        design.style.onPixels = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeSpotify).cgColor)
        return design
    }
    
    static func telegram() -> QRCode.Design {
        let design = base()
        design.style.onPixels = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeTelegram).cgColor)
        return design
    }
    
    static func tikTok() -> QRCode.Design {
        let design = base()
        design.shape.eye = QRCode.EyeShape.Circle()
        design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7)
        design.style.eye = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrColorLeafTikTok).cgColor)
        design.style.pupil = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeDefault).cgColor)
        return design
    }
    
    static func email() -> QRCode.Design {
        let design = base()
        design.style.pupil = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeEyeEmail).cgColor)
        return design
    }
    
    static func location() -> QRCode.Design {
        let design = base()
        design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7)
        design.style.onPixels = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeLocation).cgColor)
        design.shape.eye = QRCode.EyeShape.Leaf()
        design.shape.pupil = QRCode.PupilShape.RoundedRect()
        return design
    }
    
    static func phone() -> QRCode.Design {
        let design = base()
        design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 1)
        design.style.onPixels = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodePhone).cgColor)
        design.shape.eye = QRCode.EyeShape.RoundedRect()
        design.shape.pupil = QRCode.PupilShape.RoundedRect()
        return design
    }
    
    static func email1() -> QRCode.Design {
        let design = base()
        design.shape.onPixels = QRCode.PixelShape.Circle(insetFraction: 0.3)
        design.style.eye = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrColorLeafEmail).cgColor)
        design.style.pupil = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeEyeEmail1).cgColor)
        design.shape.eye = QRCode.EyeShape.Leaf()
        design.shape.pupil = QRCode.PupilShape.RoundedRect()
        return design
    }
    
    static func wifi() -> QRCode.Design {
        let design = base()
        design.shape.eye = QRCode.EyeShape.Circle()
        design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.7)
        design.style.onPixels = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodePhone).cgColor)
        return design
    }
    
    static func snapchat() -> QRCode.Design {
        let design = base()
        design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 1)
        design.style.onPixels = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeDefault).cgColor)
        design.shape.eye = QRCode.EyeShape.Leaf()
        design.shape.pupil = QRCode.PupilShape.RoundedRect()
        design.style.pupil = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeEyeSnapchat).cgColor)
        return design
    }
    
    static func phone1() -> QRCode.Design {
        let design = base()
        design.style.pupil = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeEyePhone).cgColor)
        return design
    }
    
    static func heart() -> QRCode.Design {
        let design = base()
        design.style.pupil = QRCode.FillStyle.Solid(UIColor(resource: ColorResource.qrCodeEyeHeart).cgColor)
        return design
    }
}
