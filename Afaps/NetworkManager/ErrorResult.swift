//
//  ErrorResult.swift
//  Afaps
//
//  Created by Jiraporn Praneet on 4/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import Foundation
import Alamofire

let httpStatusInvalidAccessToken = -2
let httpStatusNetworkError = -1
let httpStatusUnAuthorized = 401
let httpStatusForbidden = 403
let httpStatusInternalServerError = 500
let httpStatusBadRequest = 400

public class ErrorResult {
    var code: Int = 0
    var message: String? = ""
    var description: String? = ""

    func parseApiError(error: NSError) -> ErrorResult {
        let result = ErrorResult()
        if let description = error.userInfo["NSLocalizedDescription"] as? String {
            result.message = description
        } else if let messageError = error.userInfo["message"] as? String {
            result.message = messageError
        } else if let statusCode = error.userInfo["StatusCode"] as? Int {
            result.code = statusCode
        }
        if result.message!.hasPrefix("The Internet connection appears to be offline") {
            result.code = httpStatusNetworkError
            result.message = NSLocalizedString("Internet connection has problem, please try again.", comment: "")
        } else if result.message!.hasPrefix("The request timed out") {
            result.code = httpStatusNetworkError
            result.message = NSLocalizedString("Internet connection has problem, please try again.", comment: "")
        } else if result.message!.hasPrefix("You don\'t have permission to add user.") {
            result.code = httpStatusForbidden
            result.message = NSLocalizedString("You don't have permission to add user.", comment: "")
        } else if result.message!.hasPrefix("Incorrect username or password.") {
            result.code = httpStatusBadRequest
            result.message = NSLocalizedString("Invalid email address or password, please try again.", comment: "")
        } else if result.message!.hasPrefix("Your request was made with invalid credentials") {
            result.code = httpStatusNetworkError
            result.message = NSLocalizedString("This account is logged in from another device.", comment: "")
            showLoginViewController(result: result)

        }
        return result
    }

    func showLoginViewController(result: ErrorResult) {
        let loginViewController = R.storyboard.main.login()!
        let window = UIApplication.shared.windows[0] as UIWindow

        let alert = UIAlertController(title: NSLocalizedString("Sorry",
                                                               comment: ""),
                                      message: result.message,
                                      preferredStyle: UIAlertControllerStyle.alert)

        let okAction = UIAlertAction(title: NSLocalizedString("OK",
                                                              comment: ""),
                                     style: UIAlertActionStyle.default) { (_: UIAlertAction)
                                        -> Void in
        }

        UIView.transition(
            from: window.rootViewController!.view,
            to: loginViewController.view,
            duration: 1,
            options: .transitionCurlUp,
            completion: { _ in
                window.rootViewController = loginViewController
                UserDefaults.removeAllKey()
                alert.addAction(okAction)
                loginViewController.present(alert, animated: true, completion: nil)
        })
    }

    func showError(errorResource: ErrorResource, viewController: AnyObject) {
        if errorResource.status == httpStatusUnAuthorized {
            let alert =
                UIAlertController(
                    title: "",
                    message: String(format: "%i \n%@", errorResource.status, errorResource.message),
                    preferredStyle: UIAlertControllerStyle.alert)
            alert
                .addAction(UIAlertAction(
                    title: NSLocalizedString("OK", comment: ""),
                    style: UIAlertActionStyle.default,
                    handler: { (_) in
                        NotificationCenter
                            .default
                            .post(name: NSNotification
                                .Name(rawValue: notificationNamePresentLoginView),
                                  object: nil)
                }))
            viewController.present(alert, animated: true, completion: nil)
            return
        }
        let alert =
            UIAlertController(
                title: NSLocalizedString("Something wrong!", comment: ""),
                message: String(format: "%i \n%@", errorResource.status, errorResource.message),
                preferredStyle: UIAlertControllerStyle.alert)
        alert
            .addAction(UIAlertAction(
                title: NSLocalizedString("OK", comment: ""),
                style: UIAlertActionStyle.default,
                handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
