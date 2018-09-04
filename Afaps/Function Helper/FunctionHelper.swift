//
//  FunctionHelper.swift
//  Afaps
//
//  Created by Jiraporn Praneet on 4/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import UIKit
import OCThumbor

let notificationNamePresentLoginView: String = "presentLoginView"

class FunctionHelper: NSObject {
    func getThumborUrlFromImageUrl(imageUrlStr: String, width: Int32, height: Int32) -> NSURL {
        let thumbor: OCThumbor = OCThumbor.create(withHost: Constants.kThumborUrl, key: Constants.kThumborSecureKey)
        let builder: OCThumborURLBuilder = thumbor.buildImage(imageUrlStr)
        builder.resizeSize = ResizeSizeMake(width, height)
        return NSURL(string: builder.toUrlSafe())!
    }
}

extension Date {
    func toLongString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        return formatter.string(from: self)
    }
}
