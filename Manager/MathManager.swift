//
//  MathManager.swift
//  XDLocationManager
//
//  Created by Morgan Collino on 3/2/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

import UIKit

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
	
	
}
