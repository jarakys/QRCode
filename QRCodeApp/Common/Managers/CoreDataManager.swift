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
                   qrCodeData: Data,
                   isCreated: Bool) throws -> UUID
    func updateQRCode(id: UUID,
                      path: String,
                      qrCodeString: String,
                      image: Data,
                      qrCodeData: Data) throws
    
    func deleteQRCode(id: UUID) throws
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
    
    func updateQRCode(id: UUID, 
                      path: String,
                      qrCodeString: String,
                      image: Data,
                      qrCodeData: Data) throws {
        let fetchRequest: NSFetchRequest<QRCodeEntity> = QRCodeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id as CVarArg)
        
        let entities = try context.fetch(fetchRequest)
        
        if let entityToUpdate = entities.first {
            entityToUpdate.image = image
            entityToUpdate.qrCodeString = qrCodeString
            entityToUpdate.subtitle = path
            entityToUpdate.qrCodeData = qrCodeData
            
            try context.save()
        }
    }
    
    func addQRCode(qrCodeString: String,
                   type: String,
                   subtitle: String,
                   date: Date,
                   image: Data,
                   qrCodeData: Data,
                   isCreated: Bool) throws -> UUID {
        let id = UUID()
        let qrCodeEntity = NSEntityDescription.entity(forEntityName: "QRCodeEntity", in: context)!
        let qrCode = QRCodeEntity(entity: qrCodeEntity, insertInto: context)
        qrCode.type = type
        qrCode.qrCodeString = qrCodeString
        qrCode.uuid = id
        qrCode.date = date
        qrCode.subtitle = subtitle
        qrCode.image = image
        qrCode.isCreated = isCreated
        qrCode.qrCodeData = qrCodeData
        
        try context.save()
        return id
    }
    
    func deleteQRCode(id: UUID) throws {
        try removeQRCodes(ids: [id])
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

