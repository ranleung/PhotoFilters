//
//  Filter.swift
//  PhotoFilters
//
//  Created by Randall Leung on 10/14/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import Foundation
import CoreData

class Filter: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var favorited: NSNumber

}
