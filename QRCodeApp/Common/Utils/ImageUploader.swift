//
//  ImageUploader.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import Foundation
import FirebaseStorage

class ImageUploader {
    static func upload(data: Data) async throws -> String {
        let storage = Storage.storage()
        let ref = storage.reference()
        let imageName = UUID().uuidString
        let imageRef = ref.child("qrCodes/\(imageName).png")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        let metadataResult = try await imageRef.putDataAsync(data)
        
        return try await imageRef.downloadURL().absoluteString
    }
}
