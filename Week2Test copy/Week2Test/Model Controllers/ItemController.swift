//
//  ListController.swift
//  Week2Test
//
//  Created by Jackson Tubbs on 8/9/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    //Singleton
    static var shared = ItemController()
    
    var fetchedResultsController: NSFetchedResultsController<Item>
    
    init(){
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        // Sorts by date so that everything will append to the bottom of the list
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // Creating our results controller
        let resultController: NSFetchedResultsController<Item> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "date", cacheName: nil)
        fetchedResultsController = resultController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error at \(#function): \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD
    func createItem(name: String, isComplete: Bool = false, date: Date = Date()) {
        Item(name: name, isComplete: isComplete, date: date)
        saveToPersistentStore()
    }
    
    func deleteItem(item: Item) {
        if let moc = item.managedObjectContext {
            moc.delete(item)
            saveToPersistentStore()
        }
    }
    
    func toggleComplete(item: Item) {
        item.isComplete = !item.isComplete
        saveToPersistentStore()
    }
    
    //MARK: - Persistence
    
    // attempting to save all our Entry Data to our CoreDataStack
    private func saveToPersistentStore(){
        if CoreDataStack.context.hasChanges{
            try? CoreDataStack.context.save()
        }
    }
}
