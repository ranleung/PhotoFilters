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
        //Look this up
        self.managedObjectContext = context
    }
    
    func seedCoreData() {
        var sepia = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        sepia.name = "CISepiaTone"
        
        var gaussianBlur = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        gaussianBlur.name = "CIGaussianBlur"
        gaussianBlur.favorited = true
        
        var pixellate = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        pixellate.name = "CIPixellate"
        
        var gammaAdjust = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        gammaAdjust.name = "CIGammaAdjust"
        
        var exposureAdjust = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        exposureAdjust.name = "CIExposureAdjust"
        
        var effectChrome = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        effectChrome.name = "CIPhotoEffectChrome"
        
        var effectInstant = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        effectInstant.name = "CIPhotoEffectInstant"
        
        var effectMono = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        effectMono.name = "CIPhotoEffectMono"
        
        var effectNoir = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        effectNoir.name = "CIPhotoEffectNoir"
        
        var effectTransfer = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        effectTransfer.name = "CIPhotoEffectTransfer"
        
        
        var error: NSError?
        //& is actually memory address, instead of pointer
        self.managedObjectContext?.save(&error)
        
        if error != nil {
            println(error?.localizedDescription)
        }
    }
}