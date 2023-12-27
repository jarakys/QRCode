//
//  CoreDataManager.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import Foundation
import CoreData

protocol LocalStore {
    func addQRCode(qrCodeString: String,
                   type: String,
                   subtitle: String,
                   date: Date, 
                   image: Data,
                   isCreated: Bool) throws
}

class CoreDataManager: LocalStore {
    static let shared = CoreDataManager()
    
    let context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "Db")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        context = container.viewContext
    }
    
    func addQRCode(qrCodeString: String,
                   type: String,
                   subtitle: String,
                   date: Date,
                   image: Data,
                   isCreated: Bool) throws {
        let qrCodeEntity = NSEntityDescription.entity(forEntityName: "QRCodeEntity", in: context)!
        let qrCode = QRCodeEntity(entity: qrCodeEntity, insertInto: context)
        qrCode.type = type
        qrCode.qrCodeString = qrCodeString
        qrCode.uuid = UUID()
        qrCode.date = date
        qrCode.subtitle = subtitle
        qrCode.image = image
        qrCode.isCreated = isCreated
        
        try context.save()
    }
    
    func removeQRCodes(ids: [UUID]) throws {
        let entityName = "QRCodeEntity"
        let idAttributeName = "uuid"
        
        for objectId in ids {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let predicate = NSPredicate(format: "%K == %@", idAttributeName, objectId.debugDescription)
            fetchRequest.predicate = predicate
            
            do {
                let fetchedObjects = try context.fetch(fetchRequest) as! [NSManagedObject]
                
                for object in fetchedObjects {
                    context.delete(object)
                }
                
            } catch {
                print("Error deleting objects: \(error)")
            }
        }
        try context.save()
    }
}

