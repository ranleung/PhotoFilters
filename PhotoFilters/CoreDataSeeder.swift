//
//  CoreDataSeeder.swift
//  PhotoFilters
//
//  Created by Randall Leung on 10/14/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import Foundation
import CoreData

class CoreDataSeeder {
    var managedObjectContext: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func seedCoreData() {
        var sepia = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        sepia.name = "CISepiaTone"
        
        var gaussianBlur = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        gaussianBlur.name = "CIGaussianBlur"
        gaussianBlur.favorited = true
        
        var error: NSError?
        self.managedObjectContext?.save(&error)
        
        if error != nil {
            println(error?.localizedDescription)
        }
    }
}