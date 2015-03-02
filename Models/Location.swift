//
//  Location.swift
//  XDLocationManager
//
//  Created by Morgan Collino on 2/27/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {

    @NSManaged var timestamp: NSDate
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var run: Run

}
