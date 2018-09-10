//
//  FCMResource.swift
//  Afaps
//
//  Created by Jiraporn Praneet on 4/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import Foundation
import EVReflection

class FCMInstantIDTokenResource: EVObject {
    var message: String? = ""
}

class FCMInstantIDTokenRequest: EVObject {
    var registrationToken: String? = ""
}
