//
//  LoginViewController.swift
//  Daily Scale
//
//  Created by Michael Holler on 11/05/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let heiaHandler = HeiaHandler()
    let infolabel = UILabel()
    let userlabel = UILabel()
    let userTextField = UITextField()
    let passwdlabel = UILabel()
    let passwdTextField = UITextField()
    let loginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(infolabel)
        view.addSubview(userlabel)
        view.addSubview(userTextField)
        view.addSubview(passwdlabel)
        view.addSubview(passwdTextField)
        view.addSubview(loginButton)

        infolabel.text = "Please enter your HeiaHeia credentials to log in. Your details will not be saved by Daily Scale."
        infolabel.numberOfLines = 0
        infolabel.textAlignment = .Center
        
        userlabel.text = "Username"
        passwdlabel.text = "Password"
        
        userTextField.borderStyle = .RoundedRect
        passwdTextField.borderStyle = .RoundedRect
        
        loginButton.setTitle("Log in", forState: .Normal)
        loginButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        loginButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)

        infolabel.translatesAutoresizingMaskIntoConstraints = false
        infolabel.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50).active = true     // status bar + padding
        infolabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 20).active = true
        infolabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -20).active = true
        
        userlabel.translatesAutoresizingMaskIntoConstraints = false
        userlabel.topAnchor.constraintEqualToAnchor(infolabel.bottomAnchor, constant: 20).active = true
        userlabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 12).active = true
        
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.topAnchor.constraintEqualToAnchor(userlabel.bottomAnchor, constant: 2).active = true
        userTextField.leftAnchor.constraintEqualToAnchor(userlabel.leftAnchor, constant: -2).active = true
        userTextField.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true

        passwdlabel.translatesAutoresizingMaskIntoConstraints = false
        passwdlabel.topAnchor.constraintEqualToAnchor(userTextField.bottomAnchor, constant: 15).active = true
        passwdlabel.leftAnchor.constraintEqualToAnchor(userlabel.leftAnchor).active = true

        passwdTextField.translatesAutoresizingMaskIntoConstraints = false
        passwdTextField.topAnchor.constraintEqualToAnchor(passwdlabel.bottomAnchor, constant: 2).active = true
        passwdTextField.leftAnchor.constraintEqualToAnchor(userTextField.leftAnchor).active = true
        passwdTextField.rightAnchor.constraintEqualToAnchor(userTextField.rightAnchor).active = true

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.topAnchor.constraintEqualToAnchor(passwdTextField.bottomAnchor, constant: 15).active = true
        loginButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true

        loginButton.addTarget(self, action: #selector(buttonPressed), forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    func buttonPressed() {
    /*
        heiaHandler.loginWith(userTextField.text!, passwd: passwdTextField.text!) { success in
            if (success) {
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    */
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}