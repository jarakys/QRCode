//
//  QRCodeEntityModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import Foundation

struct QRCodeEntityModel: Hashable, Identifiable {
    public let id: UUID
    public let subtitle: String
    public let qrCodeFormat: QRCodeFormat
    public let image: Data
    public let date: Date
    public let isCreated: Bool
    public let qrCodeString: String
    
    var order: Int {
        Int(truncating: coreEntity.order ?? 0)
    }
    
    public var coreEntity: QRCodeEntity
}
