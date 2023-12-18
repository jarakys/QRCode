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
                return personalItemsSection()
                
            case .social, .utilities:
                return utilsAndSocialItemsSection()
            }
        }
    }
    
//    private static func utilsAndSocialItemsSection() -> NSCollectionLayoutSection {
//        let spacing: CGFloat = 16
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(74),
//            heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .estimated(90))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(spacing)
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
//        section.interGroupSpacing = spacing
////        section.orthogonalScrollingBehavior = .continuous
//        
//        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                      heightDimension: .estimated(200))
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: headerFooterSize,
//            elementKind:  UICollectionView.elementKindSectionHeader, alignment: .topLeading)
//        sectionHeader.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
//        section.boundarySupplementaryItems = [sectionHeader]
//        return section
//    }
    
    private static func utilsAndSocialItemsSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 16
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
//        section.orthogonalScrollingBehavior = .continuous
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(200))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind:  UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        sectionHeader.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private static func personalItemsSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 16
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(52))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(200))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind:  UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        sectionHeader.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}
