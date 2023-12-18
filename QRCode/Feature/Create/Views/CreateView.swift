//
//  CreateView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI

struct CreateView: View {
    @StateObject public var viewModel: CreateViewModel
    
    var body: some View {
        ZStack {
            List(viewModel.items, id: \.sectionIdentifier) { item in
                
            }
            .listStyle(.grouped)
        }
        .navigationTitle("Create")
        .navigationBarTitleDisplayMode(.inline)
            
    }
}

#Preview {
    CreateView(viewModel: CreateViewModel())
}
