//
//  MainScanNavigationView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import SwiftUI

struct MainScanNavigationView: View {
    @StateObject public var pathsState = PathState()
    var body: some View {
        NavigationStack(path: $pathsState.paths) {
            ScanCoordinatorView(viewModel: ScanCoordinatorViewModel())
                .environmentObject(pathsState)
                .configureNavigationBar {
                    $0.navigationBar.compactAppearance = StyleConfig.mainNavBarAppearance
                    $0.navigationBar.standardAppearance = StyleConfig.mainNavBarAppearance
                    $0.navigationBar.scrollEdgeAppearance =  StyleConfig.mainNavBarAppearance
                }
        }
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}
