//
//  ViewController.swift
//  Daily Scale
//
//  Created by Michael Holler on 10/05/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let healthHandler = HealthHandler()

    var weights = [Weight]()
    var weight = 75.0
    var priorPoint = CGPoint()
    var logWeightEnabled = true

    let weightTableView = UITableView()
    let weightInputView = UIView()
    let weightTextLabel = UILabel()
    let weightLabel = UILabel()
    let weightButton = UIButton()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGrayColor()

        view.addSubview(weightInputView)
        view.addSubview(weightTableView)
        view.addSubview(spinner)

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

        // action
        weightLabel.userInteractionEnabled = true
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        longPressRecognizer.minimumPressDuration = 0.1
        weightLabel.addGestureRecognizer(longPressRecognizer)

        weightButton.addTarget(self, action: #selector(buttonPressed), forControlEvents: UIControlEvents.TouchUpInside)

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
        
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        spinner.topAnchor.constraintEqualToAnchor(weightTableView.topAnchor, constant: 15).active = true
        
        healthHandler.authorizeHealthKit()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }

    func longPressed(sender: UILongPressGestureRecognizer) {
        if (logWeightEnabled) {
            let point = sender.locationInView(view)
            let diff = priorPoint.y - point.y

            if (sender.state == UIGestureRecognizerState.Began) {
                priorPoint = point;
                weightLabel.textColor = UIColor.lightGrayColor()
            
            } else if (sender.state == UIGestureRecognizerState.Changed) {
                if (diff < -5) {
                    weight -= 0.1;
                    priorPoint = point;
                } else if (diff > 5) {
                    weight += 0.1;
                    priorPoint = point;
                }
                weightLabel.text = String(format:"%.1f", weight);
            
            } else if (sender.state == UIGestureRecognizerState.Ended) {
                weightLabel.textColor = UIColor.blackColor()
            }
        }
    }

    func buttonPressed() {
        let adddate = NSDate()
        let addweight = Double(weightLabel.text!)!
        
        weights.insert(Weight(date: adddate, kg: addweight), atIndex: 0)
        healthHandler.saveWeight(adddate, weight: addweight)
        HeiaHandler.instance.saveWeight(adddate, weight: addweight)
        weightTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
        disableToday()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weights.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let row = indexPath.row
        
        cell.textLabel?.text = stringFromDate(weights[row].date) + ": " + String(weights[row].kg)
        
        return cell
    }

    func getData() {
        spinner.startAnimating()
        HeiaHandler.instance.getWeights() { (weights, errorcode) in
            if (errorcode == 401) {
                self.showLogin()
            } else if (errorcode > 200) {
                let alert = UIAlertController(title: "Connection not available", message: "The Internet is not available right now. Please try later again.", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                self.spinner.stopAnimating()
            } else {
                self.weights = weights
                self.showData()
                self.spinner.stopAnimating()
            }
        }
    }

    func showLogin() {
        let loginvc = LoginViewController()
        presentViewController(loginvc, animated: true, completion: nil)
    }

    // needs animation
    func showData() {
        if (weights.count > 0) {
            weight = weights[0].kg
            weightLabel.text = String(format:"%.1f", weight)
            
            if (isToday(weights[0].date)) {
                disableToday()
            } else {
                enableToday()
            }
        }
        weightTableView.reloadData()
    }
    
    func disableToday() {
        weightTextLabel.text = "Today's weight"
        weightButton.hidden = true
        logWeightEnabled = false
    }
    
    func enableToday() {
        weightTextLabel.text = "Enter weight"
        weightButton.hidden = false
        logWeightEnabled = true
    }

    
    func stringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateInFormat = dateFormatter.stringFromDate(date)

        return dateInFormat
    }
    
    func isToday(date: NSDate) -> Bool{
        var isOK = false

        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: date)
        let todayComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: NSDate())

        if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
            isOK = true
        }

        return isOK
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

