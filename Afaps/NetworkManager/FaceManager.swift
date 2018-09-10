//
//  FaceManager.swift
//  Afaps-enterprise
//
//  Created by Jiraporn Praneet on 6/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import Alamofire

let getFacePath = "/api/v1/vfaces/logs/my-logs?datetime-format=iso-8601"

typealias FaceResourceItemOnSuccess = ([FaceResource]) -> Void
typealias FaceResourceItemOnFailure = (ErrorResource) -> Void

class FaceManager: NSObject {
    func getFace(onSuccess: @escaping FaceResourceItemOnSuccess, onFailure: @escaping FaceResourceItemOnFailure) {

        BaseManager().get(path: getFacePath, onSuccess: { (response: [FaceResource]) in
            onSuccess(response)
        }, onFailure: { errorResource in
            onFailure(errorResource)
        })
    }
}
