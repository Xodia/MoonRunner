//
//  OldRunsViewController.swift
//  MoonRunner
//
//  Created by Morgan Collino on 3/14/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

import UIKit

class OldRunsViewController: UITableViewController {

	let runs = RunManager.runs()
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return runs.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RUN_IDENTIFIER", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
		var dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = .ShortStyle
		dateFormatter.timeStyle = .ShortStyle

		var run = runs[indexPath.row]
		cell.textLabel?.text = dateFormatter.stringFromDate(run.timestamp)
		cell.tag = indexPath.row
		
		return cell
    }
	

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
		if segue.destinationViewController is DetailViewController {
			
			var index = sender?.tag
			
			(segue.destinationViewController as DetailViewController).run = runs[index!]
		}
    }

}
