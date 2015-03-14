//
//  DetailViewController.swift
//  XDLocationManager
//
//  Created by Morgan Collino on 3/1/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView?
	@IBOutlet weak var dateLabel: UILabel?
	@IBOutlet weak var timeLabel: UILabel?
	@IBOutlet weak var paceLabel: UILabel?
	@IBOutlet weak var distanceLabel: UILabel?
	
	
	var run : Run! {
		didSet(setRun) {
			self.configureView()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Methods
	func configureView() {
		self.distanceLabel?.text = MathManager.stringifyDistance(self.run.distance.doubleValue)
		var formatter = NSDateFormatter()
		formatter.dateStyle = NSDateFormatterStyle.MediumStyle;
		self.dateLabel?.text = formatter.stringFromDate(self.run.timestamp)
		
		self.timeLabel?.text = String(format:"Timer: %@", MathManager.stringifySecondCount(self.run.duration.integerValue, longFormat: true))
		
		self.paceLabel?.text = String(format:"Pace: %@", MathManager.stringifyAvgPaceFromDist(self.run.distance.doubleValue, seconds: self.run.duration.integerValue))
		
		self.loadMap()
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}

extension DetailViewController : MKMapViewDelegate {
	
	func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
		
		if overlay.isKindOfClass(MRPolyline.classForCoder()) {
			var polyLine: MRPolyline = overlay as MRPolyline;
			var aRenderer: MKPolylineRenderer = MKPolylineRenderer(polyline: polyLine)
			aRenderer.strokeColor = polyLine.color
			aRenderer.lineWidth = 4
			return aRenderer;
		}
		
		return nil;
	}
	
	func mapRegion() -> MKCoordinateRegion {
		var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(0, 0), span: MKCoordinateSpanMake(0, 0))
		var initialLoc: Location = self.run.locations.firstObject as Location
		
		var minLat = (initialLoc as Location).latitude.doubleValue
		var minLng = (initialLoc as Location).longitude.doubleValue
		var maxLat = (initialLoc as Location).latitude.doubleValue
		var maxLng = (initialLoc as Location).longitude.doubleValue
		
		for location in self.run.locations.array {
			if (location as Location).latitude.doubleValue < minLat {
				minLat = (location as Location).latitude.doubleValue;
			}
			if (location as Location).longitude.doubleValue < minLng {
				minLng = (location as Location).longitude.doubleValue;
			}
			if (location as Location).latitude.doubleValue > maxLat {
				maxLat = (location as Location).latitude.doubleValue;
			}
			if (location as Location).longitude.doubleValue > maxLng {
				maxLng = (location as Location).longitude.doubleValue;
			}
		}
		
		region.center.latitude = (minLat + maxLat) / 2.0;
		region.center.longitude = (minLng + maxLng) / 2.0;
		
		region.span.latitudeDelta = (maxLat - minLat) * 1.1; // 10% padding
		region.span.longitudeDelta = (maxLng - minLng) * 1.1; // 10% padding
		
		return region;
		
	}
	
	func polyline() -> MKPolyline {
		var coords = [CLLocationCoordinate2D]();
		
		
		for location in self.run.locations.array {
			var newCoord = CLLocationCoordinate2D(latitude: (location as Location).latitude.doubleValue, longitude: (location as Location).longitude.doubleValue)
			coords.append(newCoord)
		}
		
		return MKPolyline(coordinates: &coords, count: self.run.locations.count)
	}
	
	func loadMap() {
		if self.run.locations.count > 0 {
			
			self.mapView?.hidden = false
			
			// set the map bounds
			self.mapView?.region = self.mapRegion()
			var colors = MathManager.colorSegmentsForLocations(self.run.locations.array as [Location])
			self.mapView?.addOverlays(colors)
			// make the line(s!) on the map
			
		} else {
			
			// no locations were found!
			self.mapView?.hidden = true;
			
			var alertView = UIAlertView(title: "Error", message: "Sorry, this run has no locations saved.", delegate: self, cancelButtonTitle: "OK")
			alertView.show()
		}
		
	}
}