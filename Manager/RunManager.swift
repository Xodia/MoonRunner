//
//  RunManager.swift
//  MoonRunner
//
//  Created by Morgan Collino on 3/14/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

import UIKit
import CoreData

class RunManager {
	
	class func runs() -> [Run] {
		
		let moc = self.managedObjectContext()
		let entityDescription = NSEntityDescription.entityForName("Run", inManagedObjectContext: moc)

		let request = NSFetchRequest()
		request.entity = entityDescription
		
		let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
		let sortDescriptors = [sortDescriptor]
		request.sortDescriptors = sortDescriptors
		
		var error: NSError?
		let res = moc.executeFetchRequest(request, error: &error)
		
		return res as [Run]
	}
	
	// MARK: - Managed Object Context

	class func saveContext() {
		var moc = self.managedObjectContext()
		moc.save(nil)
	}
	
	class func managedObjectContext() -> NSManagedObjectContext {
		var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		return appDelegate.managedObjectContext!;
	}
	
	class func persistentStoreCoordinator() -> NSPersistentStoreCoordinator {
		var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		return appDelegate.persistentStoreCoordinator!;
	}
	
}
