//
//  PathState.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import SwiftUI

final class PathState: ObservableObject {
    @Published public var paths = NavigationPath()
    
    public func append(_ item: any Hashable) {
        paths.append(item)
    }
    
    public func back() {
        paths.removeLast()
    }
    
    public func popToRoot() {
        paths = NavigationPath()
    }
}
