//
//  MathManager.swift
//  XDLocationManager
//
//  Created by Morgan Collino on 3/2/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

let isMetric = true
let metersInKm = 1000.0
let metersInMile = 1609.344

class MathManager: NSObject {
	

	// MARK: - Class methods
	class func stringifyDistance(meters: Double) -> String {
		
		var unitDivider = 0.0
		var unitName = ""
		
		if (isMetric) {
			unitName = "km";
			unitDivider = metersInKm;
		} else {
			unitName = "mi";
			unitDivider = metersInMile;
		}
		
		let distance = meters/unitDivider
		let result = String(format: "%.2f %@", distance, unitName)
		return result
	}
	
	class func stringifySecondCount(seconds: Int, longFormat: Bool) -> String {
		
		var remainingSeconds = seconds;
		var hours = remainingSeconds / 3600;
		remainingSeconds = remainingSeconds - hours * 3600;
		var minutes = remainingSeconds / 60;
		remainingSeconds = remainingSeconds - minutes * 60;
		
		if longFormat {
			if hours > 0 {
				return String(format: "%ihr %imin %isec", hours, minutes, remainingSeconds)
			} else if (minutes > 0) {
				return String(format: "%imin %isec", minutes, remainingSeconds)
			} else {
				return String(format: "%isec", remainingSeconds)
			}
		} else {
			if hours > 0 {
				return String(format: "%02i:%02i:%02i", hours, minutes, remainingSeconds)
			} else if minutes > 0 {
				return String(format: "%02i:%02i", minutes, remainingSeconds)
			} else {
				return String(format: "00:%02i", remainingSeconds)
			}
		}
		
	}
	
	class func stringifyAvgPaceFromDist(meters: Double, seconds: Int) -> String {
		
		if seconds == 0 || meters == 0 {
			return "0";
		}
		
		var averagePaceSecMeters = Double(seconds) / meters;
		
		var unitMultiplier = 0.0;
		var unitName = "";
		
		// metric
		if isMetric {
			unitName = "min/km";
			unitMultiplier = metersInKm;
			// U.S.
		} else {
			unitName = "min/mi";
			unitMultiplier = metersInMile;
		}
		
		var paceMin = ((averagePaceSecMeters * unitMultiplier) / 60.0);
		var paceSec = (averagePaceSecMeters * unitMultiplier - (paceMin * 60.0))
		
		return String(format: "%i:%02i %@", paceMin, paceSec, unitName)
	}
	
	class func colorSegmentsForLocations(locations: [Location]) -> [MKPolyline] {
		
		var speeds = [Double]()
		var slowestSpeed = DBL_MAX
		var fastestSpeed = 0.0
		
		var index: Int
		for index = 1; index < locations.count; index++ {
			let firstLoc = locations[index - 1]
			let secondLoc = locations[index]
			
			let firstLocCl = CLLocation(latitude: firstLoc.latitude.doubleValue, longitude: firstLoc.longitude.doubleValue)
			let secondLocCl = CLLocation(latitude: secondLoc.latitude.doubleValue, longitude: secondLoc.longitude.doubleValue)
			
			let distance = secondLocCl.distanceFromLocation(firstLocCl)
			let time = secondLoc.timestamp.timeIntervalSinceDate(firstLoc.timestamp)
			let speed = distance/time
			
			slowestSpeed = speed < slowestSpeed ? speed : slowestSpeed
			fastestSpeed = speed > fastestSpeed ? speed : fastestSpeed
			speeds.append(speed)
		}
		
		
		let meanSpeed = (slowestSpeed + fastestSpeed)/2;
		
		// RGB for red (slowest)
		let r_red = 1.0
		let r_green = 20/255.0
		let r_blue = 44/255.0
		
		// RGB for yellow (middle)
		let y_red = 1.0
		let y_green = 215/255.0
		let y_blue = 0.0
		
		// RGB for green (fastest)
		let g_red = 0.0
		let g_green = 146/255.0
		let g_blue = 78/255.0
		
		var colorSegments = [MKPolyline]();
		
		for index = 1; index < locations.count; index++ {
			let firstLoc = locations[index - 1]
			let secondLoc = locations[index]

			var coords = [CLLocationCoordinate2D]()
			var firstLocation = CLLocationCoordinate2DMake(firstLoc.latitude.doubleValue, firstLoc.longitude.doubleValue)
			var secondLocation = CLLocationCoordinate2DMake(secondLoc.latitude.doubleValue, secondLoc.longitude.doubleValue)
			
			coords.append(firstLocation)
			coords.append(secondLocation)

			let speed = speeds[index - 1];
			var color = UIColor.blackColor();
			
			// between red and yellow
			if speed < meanSpeed {
				var ratio = (speed - slowestSpeed) / (meanSpeed - slowestSpeed);
				let r = CGFloat(r_red + ratio * (y_red - r_red))
				let g = CGFloat(r_green + ratio * (y_green - r_green))
				let b = CGFloat(r_blue + ratio * (y_blue - r_blue))
				color = UIColor(red: r, green: g, blue: b, alpha: CGFloat(1.0));
			} else {
				var ratio = (speed - meanSpeed) / (fastestSpeed - meanSpeed);
				let r = CGFloat(y_red + ratio * (g_red - y_red))
				let g = CGFloat(y_green + ratio * (g_green - y_green))
				let b = CGFloat(y_blue + ratio * (g_blue - y_blue))
				color = UIColor(red: r, green: g, blue: b, alpha: CGFloat(1.0));
			}
			
			var segment = MRPolyline(coordinates: &coords, count: 2)
			segment.color = color;
			colorSegments.append(segment);
		}
		
		return colorSegments;
	}

}
