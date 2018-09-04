//
//  LoginViewController.swift
//  Afaps
//
//  Created by Jiraporn Praneet on 4/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var theScrollView: UIScrollView!
    @IBOutlet var showPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        let tapGestureRecognizerKeyboard: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizerKeyboard)

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: Scrollview Notification
    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)!.cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset: UIEdgeInsets = theScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        theScrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        theScrollView.contentInset = contentInset
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginClicked(self)
        }
        return true
    }

    func setLoginButtonIsEnabled() {
        let editTexts = [emailTextField, passwordTextField]
        let emptyCount = editTexts
            .filter { (textField) -> Bool in
                textField?.text == "" }
            .count
        loginButton.isEnabled = emptyCount == 0
    }

    @IBAction func emailFieldEditingChanged(_ sender: Any) {
        setLoginButtonIsEnabled()
    }

    @IBAction func passwordFieldEditingChanged(_ sender: Any) {
        setLoginButtonIsEnabled()
    }

    // MARK: IBAction Login
    @IBAction func loginClicked(_ sender: Any) {
        self.dismissKeyboard()
        startAnimating()
        LoginManager()
            .login(username: emailTextField.text!,
                   password: passwordTextField.text!,
                   onSuccess: {(resource) in
                    self.stopAnimating()
                    print("access Token :\(resource)")
                    UserDefaults.saveAccessToken(value: resource.accessToken!)
                    self.performSegue(withIdentifier: R.segue.loginViewController.toMainView, sender: nil)
            }, onFailure: { errorResource in
                self.stopAnimating()
                ErrorResult().showError(errorResource: errorResource, viewController: self)
            })
    }

    // MARK: Secure Text Entry
    @IBAction func showPasswordClicked() {
        let origImage = R.image.ic_remove_red_eye()
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        showPasswordButton.setImage(tintedImage, for: .normal)

        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.tintColor = UIColor.red
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.tintColor = UIColor.black
        }
    }
}
