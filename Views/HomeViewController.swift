//
//  HomeViewController.swift
//  XDLocationManager
//
//  Created by Morgan Collino on 2/27/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

	var managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
	

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		println(managedObjectContext)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		var nextController : UIViewController = segue.destinationViewController as UIViewController;
		if nextController.isKindOfClass(NewRunViewController.classForCoder()) {
			(nextController as NewRunViewController).managedObjectContext = self.managedObjectContext
		}
	}
}

