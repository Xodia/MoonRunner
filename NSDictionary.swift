//
//  Dictionary.swift
//  MoonRunner
//
//  Created by Morgan Collino on 3/7/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

import Foundation

extension NSDictionary {

	func toJson(prettyPrinted: Bool) -> String {
		var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
		if NSJSONSerialization.isValidJSONObject(self) {
			if let data = NSJSONSerialization.dataWithJSONObject(self, options: options, error: nil) {
				if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
					return string
				}
			}
		}
		return ""
	}
	
}