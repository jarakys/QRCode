//
//  CustomLayout.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import UIKit

public extension UICollectionViewLayout {
    static func composed(sections: [CreateQRCodeSectionModel]) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = sections[sectionIndex]
            switch section.sectionIdentifier {
            case .personal:
                return offerSection()
                
            case .social, .utilities:
                return titledTopItemsSection()
                
            default: return offerSection()
            }
        }
    }
    
    private static func offerSection() -> NSCollectionLayoutSection {
        let topNestedItemLeading = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        topNestedItemLeading.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.4)), subitems: [topNestedItemLeading])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private static func titledTopItemsSection() -> NSCollectionLayoutSection {
        let topNestedItemLeading = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        topNestedItemLeading.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.45), heightDimension: .absolute(150)), subitems: [topNestedItemLeading])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(200)) // <- estimated will dynamically adjust to less height if needed.
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind:  UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}
