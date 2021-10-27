//
//  CoreDataService.swift
//  Contacts
//
//  Created by SongWei Chuah on 26/10/21.
//

import UIKit
import CoreData
import UIKit

protocol CoreDataServiceType {
    func addContactList(list: [ContactViewModel])
    func getContactList() -> [Contact]
    func updateContact(_contact: ContactViewModel)
    func save()
    func deleteContactIfNeeded()
}

class CoreDataService: CoreDataServiceType {
    let persistentContainer: NSPersistentContainer!
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    func addContactList(list: [ContactViewModel]) {
        var contactInstances = [Contact]()
        for contactVM in list {
            let contactInstance = Contact(context: self.persistentContainer.viewContext)
            contactInstance.id = String(contactVM.id)
            contactInstance.firstName = contactVM.firstName
            contactInstance.lastName = contactVM.lastName
            contactInstance.email = contactVM.email
            contactInstance.avatarUrlString = contactVM.avatarUrlString
            contactInstances.append(contactInstance)
        }
        self.save()
    }
    
    func getContactList() -> [Contact] {
        var fetchContact = [Contact]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            fetchContact = try self.persistentContainer.viewContext.fetch(fetchRequest) as! [Contact]
        } catch {
            print("Error while fetching contact")
        }
        return fetchContact
    }
    
    func updateContact(_contact: ContactViewModel) {
        var contact = [Contact]()
        let fetchRequest: NSFetchRequest<Contact>
        fetchRequest = Contact.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(_contact.id)")
        
        let context = persistentContainer.viewContext
        do {
            contact = try context.fetch(fetchRequest)
        } catch {
            print("error while fetching contact")
        }
        if let editContact = contact.first {
            editContact.firstName = _contact.firstName
            editContact.lastName = _contact.lastName
        }
        save()
    }
    
    func save() {
        if self.persistentContainer.viewContext.hasChanges {
            do {
                try self.persistentContainer.viewContext.save()
            } catch {
                print("save data failed")
            }
        }
    }
    
    func deleteContactIfNeeded() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.persistentContainer.viewContext.execute(deleteRequest)
        } catch {
            print("Error while deleting image")
        }
        save()
    }
}
