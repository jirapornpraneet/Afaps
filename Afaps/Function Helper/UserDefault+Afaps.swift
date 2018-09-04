//
//  UserDefault+Afaps.swift
//  Afaps
//
//  Created by Jiraporn Praneet on 4/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import UIKit
import Foundation

let kAccessToken: String = "kAccessToken"
let kFCMToken: String = "kFCMToken"

extension UserDefaults {

    class func saveAccessToken(value: String) {
        UserDefaults.standard.setValue(value, forKey: kAccessToken)
        UserDefaults.standard.synchronize()
    }

    class func loadAccessToken() -> String {
        return UserDefaults.standard.string(forKey: kAccessToken) ?? ""
    }

    class func removeAccessToken() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: kAccessToken)
    }

    class func saveFCMToken(value: String) {
        UserDefaults.standard.setValue(value, forKey: kFCMToken)
        UserDefaults.standard.synchronize()
    }

    class func loadFCMToken() -> String? {
        return UserDefaults.standard.string(forKey: kFCMToken)
    }

    class func removeFCMToken() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: kFCMToken)
    }

    class func removeAllKey() {
        for key in Array(UserDefaults.standard.dictionaryRepresentation().keys) {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
