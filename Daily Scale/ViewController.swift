//
//  ViewController.swift
//  Daily Scale
//
//  Created by Michael Holler on 10/05/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let feedTableView = UITableView()
    let feed = [76.2, 77.8, 77.4]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(feedTableView)

        feedTableView.backgroundColor = UIColor.whiteColor()
//        feedTableView.separatorStyle = .None
        feedTableView.rowHeight = UITableViewAutomaticDimension
        feedTableView.estimatedRowHeight = 75
        feedTableView.allowsSelection = false

        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        feedTableView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20).active = true         // status bar height
        feedTableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        feedTableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        feedTableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -49).active = true   // tab bar height
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }

    // Conforming to UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let row = indexPath.row
        
        cell.textLabel?.text = String(feed[row])
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

