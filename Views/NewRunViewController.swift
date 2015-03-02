//
//  NewRunViewController.swift
//  XDLocationManager
//
//  Created by Morgan Collino on 2/28/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class NewRunViewController: UIViewController {

	var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
	var run : Run!
	
	var seconds = 0
	var distance = 0.0
	var locationManager = CLLocationManager()
	var locations = [AnyObject]()
	var timer: NSTimer!
	
	@IBOutlet weak var startButton: UIButton?
	@IBOutlet weak var stopButton: UIButton?
	@IBOutlet weak var promptLabel: UILabel?
	@IBOutlet weak var timeLabel: UILabel?
	@IBOutlet weak var distLabel: UILabel?
	@IBOutlet weak var paceLabel: UILabel?
	
	
	
	let detailSegue:String = "RunDetails"

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "eachSecond", userInfo: nil, repeats: true)
		self.startLocationUpdates()

        // Do any additional setup after loading the view.
    }

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.timer.invalidate()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	override func viewWillAppear(animated: Bool) {
	
		super.viewWillAppear(animated)
		self.startButton?.hidden = false
		self.promptLabel?.hidden = false
		self.timeLabel?.text = ""
		self.timeLabel?.hidden = true
		self.distLabel?.hidden = true
		self.paceLabel?.hidden = true
		self.stopButton?.hidden = true
	}
	
	
	// MARK: IBActions
	
	@IBAction func startPressed(sender: UIButton) {
	
		// hide the start UI
		self.startButton?.hidden = true
		self.promptLabel?.hidden = true
		
		// show the running UI
		self.timeLabel?.hidden = false;
		self.distLabel?.hidden = false;
		self.paceLabel?.hidden = false;
		self.stopButton?.hidden = false;

	}
	
	@IBAction func stopPressed(sender: UIButton) {
	
		var actionSheet : UIActionSheet =  UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Done", otherButtonTitles: "Save", "Discard")
		
		
		actionSheet.actionSheetStyle = UIActionSheetStyle.Default
		actionSheet.showInView(self.view)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		(segue.destinationViewController as DetailViewController).run = self.run

	}

	// MARK: - Core
	
	func eachSecond() {
		self.seconds++;
		self.timeLabel?.text = String(format: "Timer: %@", MathManager.stringifySecondCount(self.seconds, longFormat: false))
		
		self.distLabel?.text = String(format: "Distance: %@", MathManager.stringifyDistance(self.distance))
			
		self.paceLabel?.text = String(format: "Pace: %@", MathManager.stringifyAvgPaceFromDist(self.distance, seconds: self.seconds))
	}
	
	func startLocationUpdates() {
		
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.activityType = CLActivityType.OtherNavigation
		self.locationManager.distanceFilter = 10; // meters
		self.locationManager.requestAlwaysAuthorization()

		
		self.locationManager.startUpdatingLocation()
	}
	
	
	func saveRun() {
		
		var newRun: Run = NSEntityDescription.insertNewObjectForEntityForName("Run", inManagedObjectContext: self.managedObjectContext!) as Run
 
		newRun.distance = self.distance
		newRun.duration = self.seconds
		newRun.timestamp = NSDate(timeIntervalSinceNow: 0);
 
		var locationArray = [Location]()
		for location in self.locations {
			var locationObject: Location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: self.managedObjectContext!) as Location
 
			locationObject.timestamp = (location as CLLocation).timestamp
			locationObject.latitude = (location as CLLocation).coordinate.latitude
			locationObject.longitude = (location as CLLocation).coordinate.longitude
			locationArray.append(locationObject)
		}
 
		newRun.locations = NSOrderedSet(array: locationArray)
		self.run = newRun;
 
		// Save the context.
		var error: NSError? = nil
		if (self.managedObjectContext?.save(&error) == false) {
			println("Unresolved error \(error) \(error.debugDescription)")
			abort();
		}
	}
	
}

// MARK: - ActionSheetDelegate
extension NewRunViewController : UIActionSheetDelegate {
	
	func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
		
		if buttonIndex == 0 {
			self.saveRun()
			self.performSegueWithIdentifier(detailSegue, sender: nil)
		} else if buttonIndex == 1 {
			self.navigationController?.popToRootViewControllerAnimated(true)
		}
	}
}

// MARK: - CoreLocation Delegate
extension NewRunViewController: CLLocationManagerDelegate {
	
	func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
		println(error)
	}
	
	func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
		println("didStart")
	}
	
	func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
		println("didUpdateToLocation")
	}
	
	func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
		println("New Locations : \(locations)")
		for newLocation in locations {
			if newLocation.horizontalAccuracy < 20 {
				
				if self.locations.count > 0 {
					self.distance += newLocation.distanceFromLocation(self.locations.last as CLLocation)
				}
				self.locations.append(newLocation)
			}
		
		}
	}
}
