//
//  Run.swift
//  XDLocationManager
//
//  Created by Morgan Collino on 2/27/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

import Foundation
import CoreData

class Run: NSManagedObject {

    @NSManaged var distance: NSNumber
    @NSManaged var duration: NSNumber
    @NSManaged var timestamp: NSDate
    @NSManaged var locations: NSOrderedSet

}
