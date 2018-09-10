//
//  FaceResource.swift
//  Afaps-enterprise
//
//  Created by Jiraporn Praneet on 6/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import Foundation
import EVReflection

class FaceResource: EVObject {
    var userId: Int?
    var similarity: String?
    var createdAt: Date?
    var user: String?
    var location: String?
    var imageUrl: String?

    override func decodePropertyValue(value: Any, key: String) -> Any? {
        if key == "createdAt" {
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: (value as? String)!)
            return date
        }
        return value
    }
}
