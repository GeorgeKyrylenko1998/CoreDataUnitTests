//
//  ClientsManager.swift
//  ClientsDB
//
//  Created by George Kyrylenko on 12.08.2023.
//

import Foundation
import CoreData

public class ClientsManger {
    public var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Clients")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.automaticallyMergesChangesFromParent = true
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    public func addContact(firstName: String,
                    lastName: String,
                    email: String,
                    id: String) -> Client? {
        let client = Client(context: persistentContainer.viewContext)
        client.firstName = firstName
        client.lastName = lastName
        client.email = email
        client.id = id
        try? persistentContainer.viewContext.save()
        return client
    }
    
    public func remove(by id: String, completion: @escaping () -> ()) {
        persistentContainer.performBackgroundTask { context in
            let request = Client.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            let client = try? context.fetch(request).first
            if let client {
                context.delete(client)
            }
            try? context.save()
            completion()
        }
    }
    
    public func getAllClients() -> [Client] {
        let request = Client.fetchRequest()
        let clients = (try? persistentContainer.viewContext.fetch(request)) ?? []
        return clients
    }
}
