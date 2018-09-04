//
//  AppDelegate.swift
//  Afaps
//
//  Created by Jiraporn Praneet on 4/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        Messaging.messaging().delegate = self

        if !UserDefaults.loadAccessToken().isEmpty {
            self.window?.rootViewController = R.storyboard.main.mainNavigation()
        }

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })

        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        NotificationCenter.default.addObserver(self, selector: #selector(presentLoginView),
                                               name: NSNotification.Name(rawValue: notificationNamePresentLoginView),
                                               object: nil)
        return true
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        UserDefaults.saveFCMToken(value: fcmToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    @objc func presentLoginView() {
        UserDefaults.removeAccessToken()
        let viewController = R.storyboard.main.login()!
        let window = UIApplication.shared.windows[0] as UIWindow

        UIView.transition(
            from: window.rootViewController!.view,
            to: viewController.view,
            duration: 1,
            options: .transitionFlipFromTop,
            completion: { _ in
                window.rootViewController = viewController
                UserDefaults.removeAllKey()
        })
    }
}
