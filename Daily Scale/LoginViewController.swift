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

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(stack)

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
        
        infolabel.text = "Please enter your HeiaHeia credentials to log in. Your details will not be saved by Daily Scale."
        infolabel.numberOfLines = 0
        infolabel.textAlignment = .Center

        errorlabel.text = "Unfortunately these credentials did not work. Please check them and try again."
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

/*
        infolabel.translatesAutoresizingMaskIntoConstraints = false
//        infolabel.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50).active = true     // status bar + padding
        infolabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 20).active = true
        infolabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -20).active = true
        
        errorlabel.translatesAutoresizingMaskIntoConstraints = false
//        errorlabel.topAnchor.constraintEqualToAnchor(infolabel.bottomAnchor, constant: 20).active = true
        errorlabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 20).active = true
        errorlabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -20).active = true

        userlabel.translatesAutoresizingMaskIntoConstraints = false
        userlabel.topAnchor.constraintEqualToAnchor(errorlabel.bottomAnchor, constant: 20).active = true
//        userlabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 12).active = true

        userTextField.translatesAutoresizingMaskIntoConstraints = false
//        userTextField.topAnchor.constraintEqualToAnchor(userlabel.bottomAnchor, constant: 2).active = true
        userTextField.leftAnchor.constraintEqualToAnchor(userlabel.leftAnchor, constant: -2).active = true
        userTextField.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true

        passwdlabel.translatesAutoresizingMaskIntoConstraints = false
        passwdlabel.topAnchor.constraintEqualToAnchor(userTextField.bottomAnchor, constant: 15).active = true
//        passwdlabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true

        passwdTextField.translatesAutoresizingMaskIntoConstraints = false
//        passwdTextField.topAnchor.constraintEqualToAnchor(passwdlabel.bottomAnchor, constant: 2).active = true
        passwdTextField.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        passwdTextField.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true

        loginButton.translatesAutoresizingMaskIntoConstraints = false
//        loginButton.topAnchor.constraintEqualToAnchor(passwdTextField.bottomAnchor, constant: 15).active = true
        loginButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        */
        
        loginButton.addTarget(self, action: #selector(buttonPressed), forControlEvents: UIControlEvents.TouchUpInside)

        errorlabel.hidden = true
    }
    
    func buttonPressed() {
        // check input
        let user = emailTextField.text!
        let passwd = passwdTextField.text!
        
        if (user.isEmpty || passwd.isEmpty) {
            self.toggleError(false)
        } else {
            HeiaHandler.instance.loginWith(emailTextField.text!, passwd: passwdTextField.text!) { success in
                if (success) {
                    self.toggleError(true)
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.toggleError(false)
                    print("This is bullshit")
                }
            }
        }
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