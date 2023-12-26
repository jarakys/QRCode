//
//  ShareQRImage.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import SwiftUI

struct ShareQRImage: Transferable {
    func generateReport() async -> String {
        print("Generating...")
        // do some work...
        return "A generated report"
    }
    
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation { report in
            await report.generateReport()
        }
    }
}
