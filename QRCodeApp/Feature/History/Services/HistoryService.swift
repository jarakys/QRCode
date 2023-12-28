//
//  HistoryService.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import Foundation
import CoreData
import Combine

final class HistoryService: NSObject, NSFetchedResultsControllerDelegate {
    private var fetchedResultsController: NSFetchedResultsController<QRCodeEntity>
    
    public var emmiter = PassthroughSubject<[QRCodeEntitySection], Never>()

    override init() {
        let request = NSFetchRequest<QRCodeEntity>(entityName: "QRCodeEntity")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \QRCodeEntity.date, ascending: true)
        ]
        self.fetchedResultsController = .init(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath:  #keyPath(QRCodeEntity.formattedDate), cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
    }

    public func fetch(isCreated: Bool) throws {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "isCreated == \(isCreated)")
        try fetch()
    }
    
    public func fetch() throws {
        try fetchedResultsController.performFetch()
        handleFetch()
    }
    
    private func handleFetch() {
        let sections = fetchedResultsController.sections ?? []
        let qrCodeSections = convert(sections: sections)
        emmiter.send(qrCodeSections)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let sections = fetchedResultsController.sections ?? []
        let qrCodeSections = convert(sections: sections)
        emmiter.send(qrCodeSections)
    }
    
    private func convert(sections: [NSFetchedResultsSectionInfo]) -> [QRCodeEntitySection] {
        let qrCodeSections = sections.map { section in
            let objects = section.objects?.compactMap({ $0 as? QRCodeEntity }) ?? []
            let qrCodeObjects = objects.compactMap({ QRCodeEntityModel(id: $0.uuid!, 
                                                                       subtitle: $0.subtitle ?? "",
                                                                       qrCodeFormat: QRCodeFormat(rawValue: $0.type ?? "") ?? .phone,
                                                                       image: $0.image!,
                                                                       date: $0.date ?? Date(),
                                                                       isCreated: $0.isCreated, 
                                                                       qrCodeString: $0.qrCodeString ?? "", 
                                                                       coreEntity: $0)
            })
            let sectionModel = QRCodeEntitySection(title: section.name, items: qrCodeObjects)
            return sectionModel
        }
        return qrCodeSections
    }
}
