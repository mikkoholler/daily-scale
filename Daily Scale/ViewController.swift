//
//  ViewController.swift
//  Daily Scale
//
//  Created by Michael Holler on 10/05/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let heiaHandler = HeiaHandler()
    var weights = [Weight]()
    var weight = 75.0
    
    let weightTableView = UITableView()
    let weightInputView = UIView()
    let weightTextLabel = UILabel()
    let weightLabel = UILabel()
    let weightButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGrayColor()

        view.addSubview(weightInputView)
        view.addSubview(weightTableView)

        weightInputView.backgroundColor = UIColor.whiteColor()

        weightInputView.translatesAutoresizingMaskIntoConstraints = false
        weightInputView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20).active = true            // status bar height
        weightInputView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        weightInputView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        weightInputView.heightAnchor.constraintEqualToConstant(100).active = true

        weightInputView.addSubview(weightTextLabel)
        weightInputView.addSubview(weightLabel)
        weightInputView.addSubview(weightButton)
        
        // looks
        weightTextLabel.text = "Enter weight"
        weightTextLabel.textColor = UIColor.blackColor()

        weightLabel.font = weightLabel.font.fontWithSize(48)
        weightLabel.text = String(format:"%.1f", weight)

        weightButton.setTitle("Save", forState: .Normal)
        weightButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        weightButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)

        // layout
        weightTextLabel.translatesAutoresizingMaskIntoConstraints = false
        weightTextLabel.topAnchor.constraintEqualToAnchor(weightInputView.topAnchor, constant: 10).active = true
        weightTextLabel.leftAnchor.constraintEqualToAnchor(weightInputView.leftAnchor, constant: 10).active = true

        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.centerXAnchor.constraintEqualToAnchor(weightInputView.centerXAnchor).active = true
        weightLabel.centerYAnchor.constraintEqualToAnchor(weightInputView.centerYAnchor).active = true
        
        weightButton.translatesAutoresizingMaskIntoConstraints = false
        weightButton.bottomAnchor.constraintEqualToAnchor(weightInputView.bottomAnchor, constant: -10).active = true
        weightButton.rightAnchor.constraintEqualToAnchor(weightInputView.rightAnchor, constant: -10).active = true

        weightTableView.backgroundColor = UIColor.whiteColor()
//        feedTableView.separatorStyle = .None
        weightTableView.rowHeight = UITableViewAutomaticDimension
        weightTableView.estimatedRowHeight = 75
        weightTableView.allowsSelection = false

        weightTableView.translatesAutoresizingMaskIntoConstraints = false
        weightTableView.topAnchor.constraintEqualToAnchor(weightInputView.bottomAnchor, constant: 10).active = true
        weightTableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        weightTableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        weightTableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true   // tab bar height: ", constant: -49"
        
        weightTableView.delegate = self
        weightTableView.dataSource = self
    }

    // Conforming to UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weights.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let row = indexPath.row
        
        cell.textLabel?.text = weights[row].date + ": " + String(weights[row].weight)
        
        return cell
    }

    func getData() {
        heiaHandler.getWeights() { weights in
            self.weights = weights
            self.weightTableView.reloadData()
            
            print("Got \(weights.count) items")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

