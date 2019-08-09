//
//  CoreDataStack.swift
//  Week2Test
//
//  Created by Jackson Tubbs on 8/9/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Week2Test")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error) \(error.userInfo)")
            }
        })
        return container
    }()
    static var context: NSManagedObjectContext{ return container.viewContext }
}
