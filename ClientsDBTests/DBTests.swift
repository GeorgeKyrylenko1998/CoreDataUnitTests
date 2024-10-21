//
//  DBTests.swift
//  ClientsDBTests
//
//  Created by George Kyrylenko on 12.08.2023.
//

import XCTest
import ClientsDB
import CoreData

final class DBTests: XCTestCase {
    
    var clientsManager: ClientsManger!

    override func setUpWithError() throws {
        let container = NSPersistentContainer(name: "Clients")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.automaticallyMergesChangesFromParent = true
            if let error = error as NSError? {
                XCTAssertNil(error, "Failed to load CoreData stack: \(error.localizedDescription)")
            }
        })
        clientsManager = ClientsManger(persistentContainer: container)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func createConatct() -> String {
        let id = UUID().uuidString
        clientsManager.addContact(firstName: "FirstName",
                                  lastName: "LastName",
                                  email: "email@email.email",
                                  id: id)
        return id
    }
    
    func testAddClients() {
        let id = createConatct()
        let users = clientsManager.getAllClients()
        
        XCTAssertEqual(users.count, 1)
        let firstUser = users.first
        XCTAssertNotNil(firstUser)
        XCTAssertEqual(firstUser?.id, id)
    }
    
    func testRemoveContact() {
        let id1 = createConatct()
        let id2 = createConatct()
        var users = clientsManager.getAllClients()
        XCTAssertEqual(users.count, 2)
        let removeFirstContactExpecxtation = expectation(description: "RemoveContact")
        clientsManager.remove(by: id1) {
            removeFirstContactExpecxtation.fulfill()
        }
        wait(for: [removeFirstContactExpecxtation], timeout: 2)
        users = clientsManager.getAllClients()
        XCTAssertEqual(users.count, 1)
        let removeSecondContactExpecxtation = expectation(description: "RemoveContact2")
        clientsManager.remove(by: id2) {
            removeSecondContactExpecxtation.fulfill()
        }
        wait(for: [removeSecondContactExpecxtation], timeout: 2)
        users = clientsManager.getAllClients()
        XCTAssertEqual(users.count, 0)
    }
}
