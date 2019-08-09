//
//  List+Convenience.swift
//  Week2Test
//
//  Created by Jackson Tubbs on 8/9/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import CoreData

extension Item {

    @discardableResult
    convenience init(name: String, isComplete: Bool, date: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        // Memberwize
        self.init(context: context)
        // Convenience
        self.name = name
        self.isComplete = isComplete
        self.date = date
    }
}
