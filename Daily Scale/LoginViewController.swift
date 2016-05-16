//
//  LoginViewController.swift
//  Daily Scale
//
//  Created by Michael Holler on 11/05/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let stack = UIStackView()
    let emailstack = UIStackView()
    let passwdstack = UIStackView()
    let infolabel = UILabel()
    let errorlabel = UILabel()
    let emaillabel = UILabel()
    let emailTextField = UITextField()
    let passwdlabel = UILabel()
    let passwdTextField = UITextField()
    let loginButton = UIButton()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(stack)
        view.addSubview(spinner)

        stack.axis = UILayoutConstraintAxis.Vertical
        stack.spacing = 20

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50).active = true     // status bar + padding
        stack.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 20).active = true
        stack.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -20).active = true

        stack.addArrangedSubview(infolabel)
        stack.addArrangedSubview(errorlabel)
        stack.addArrangedSubview(emailstack)
        stack.addArrangedSubview(passwdstack)
        stack.addArrangedSubview(loginButton)

        emailstack.axis = UILayoutConstraintAxis.Vertical
        emailstack.spacing = 5
        emailstack.addArrangedSubview(emaillabel)
        emailstack.addArrangedSubview(emailTextField)

        passwdstack.axis = UILayoutConstraintAxis.Vertical
        passwdstack.spacing = 5
        passwdstack.addArrangedSubview(passwdlabel)
        passwdstack.addArrangedSubview(passwdTextField)
        
        infolabel.text = "Please log in with your HeiaHeia credentials to save weights. Your details will not be saved by Daily Scale."
        infolabel.numberOfLines = 0
        infolabel.textAlignment = .Center

        errorlabel.text = "Unfortunately the entered credentials did not work. Please check them and try again."
        errorlabel.numberOfLines = 0
        errorlabel.textAlignment = .Center
        errorlabel.textColor = UIColor.redColor()
        
        emaillabel.text = "Email"
        emailTextField.borderStyle = .RoundedRect
        emailTextField.autocapitalizationType = .None
        emailTextField.autocorrectionType = .No
        
        passwdlabel.text = "Password"
        passwdTextField.borderStyle = .RoundedRect
        passwdTextField.secureTextEntry = true
        
        loginButton.setTitle("Log in", forState: .Normal)
        loginButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        loginButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        
        loginButton.addTarget(self, action: #selector(buttonPressed), forControlEvents: UIControlEvents.TouchUpInside)

        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        spinner.centerYAnchor.constraintEqualToAnchor(loginButton.centerYAnchor, constant: 35).active = true        // button centerY off by 35

        errorlabel.hidden = true
    }
    
    func buttonPressed() {
        // check input
        let user = emailTextField.text!
        let passwd = passwdTextField.text!
        
        if (user.isEmpty || passwd.isEmpty) {
            self.toggleError(false)
        } else {
            showSpinner()
            HeiaHandler.instance.loginWith(emailTextField.text!, passwd: passwdTextField.text!) { success in
                if (success) {
                    self.toggleError(true)
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.toggleError(false)
                }
                self.hideSpinner()
            }
        }
    }
    
    // scroll login button to view on small screen: NSNotificationCenter.defaultCenter...
    
    func showSpinner() {
        spinner.startAnimating()
        loginButton.hidden = true
    }

    func hideSpinner() {
        spinner.stopAnimating()
        loginButton.hidden = false
    }
    
    func toggleError(hidden: Bool) {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.errorlabel.hidden = hidden
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}