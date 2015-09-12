//
//  VroomViewController.swift
//  Vroom
//
//  Created by Shamilla Selamat on 9/12/15.
//  Copyright (c) 2015 Shamilla Selamat. All rights reserved.
//

import UIKit

class VroomViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField! { didSet { usernameTextField.delegate = self } }
    @IBOutlet weak var passwordTextField: UITextField! { didSet { passwordTextField.delegate = self } }
    @IBOutlet weak var scrollView: UIScrollView! { didSet { scrollView.contentSize = contentView.frame.size } }
    @IBOutlet weak var contentView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(contentView)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Keyboard Management
    
    var activeTextField: UITextField?
    
    // Called to identify active text field
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        scrollView.scrollEnabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        scrollView.scrollEnabled = false
    }
    
    // Called when user press return key to dismiss keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            login()
        }
        return true
    }
    
    // Called when the UIKeyboardDidShowNotification is sent
    func keyboardWillBeShown(notification: NSNotification) {
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it to make it visible
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        let activeTextFieldRect: CGRect? = activeTextField?.frame
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        if (!CGRectContainsPoint(aRect, activeTextFieldOrigin!)) {
            scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - Navigation

    @IBAction func loginTouchDown(sender: UIButton) {
        login()
    }
    
    func login() {
        let alertController = UIAlertController(title: "Welcome", message: "Welcome" + ((usernameTextField.text == "") ? "!" : " \(usernameTextField.text)!"), preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
        self.presentViewController(alertController, animated: true, completion: nil);
    }

}
