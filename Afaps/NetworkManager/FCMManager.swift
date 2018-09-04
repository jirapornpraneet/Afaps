//
//  FCMManager.swift
//  Afaps
//
//  Created by Jiraporn Praneet on 4/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import Alamofire

let postFCMInstantIDTokenPath = "/api/v1/notification/fcm/registration-token"

typealias FCMInstantIDTokenResourceOnSuccess = (FCMInstantIDTokenResource) -> Void
typealias FCMInstantIDTokenResourceOnFailure = (ErrorResource) -> Void

class FCMManager: NSObject {
    func postFCMInstantIDToken(registrationToken: String,
                               onSuccess: @escaping  FCMInstantIDTokenResourceOnSuccess,
                               onFailure: @escaping FCMInstantIDTokenResourceOnFailure) {
        let params = ["registrationToken": registrationToken]

        BaseManager().post(path: postFCMInstantIDTokenPath,
                           params: params,
                           onSuccess: { (response: FCMInstantIDTokenResource) in
                            onSuccess(response)
        }, onFailure: { errorResource in
            onFailure(errorResource)
        })
    }
}
