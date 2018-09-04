//
//  BaseManager.swift
//  Afaps
//
//  Created by Jiraporn Praneet on 4/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import EVReflection

typealias OnFailure = (ErrorResource) -> Void

class BaseManager: NSObject {

    public func get<T: EVObject>(path: String,
                                 params: Parameters? = nil,
                                 onSuccess: @escaping ([T]) -> Void,
                                 onFailure: @escaping OnFailure) {
        let headers = ["Authorization": "Bearer " + UserDefaults.loadAccessToken()]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire
            .request(Constants.kApiUrl + path, parameters: params, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseArray {(response: DataResponse<[T]>) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if response.result.isSuccess {
                    onSuccess(response.value!)
                    return
                }
                if !(response.error! is AFError) {
                    let errorResource = ErrorResource()
                    errorResource.status = httpStatusNetworkError
                    errorResource.message = (response.error?.localizedDescription)!
                    onFailure(errorResource)
                }

                let errorString = String(data: response.data!, encoding: String.Encoding.utf8)!
                let errorResource = ErrorResource(json: errorString)
                let error = response.error as? AFError
                errorResource.status =
                    errorResource.status == 0 ?
                        error?.responseCode ??
                        httpStatusInternalServerError :
                    errorResource.status
                errorResource.message = errorResource.message == "" ?
                    "Internal Server Error. Please try again." :
                    errorResource.message
                onFailure(errorResource)
        }
    }

    public func post<T: EVObject>(path: String,
                                  params: Parameters? = nil,
                                  onSuccess: @escaping (T) -> Void,
                                  onFailure: @escaping OnFailure) {
        let headers = ["Authorization": "Bearer " + UserDefaults.loadAccessToken()]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        Alamofire
            .request(Constants.kApiUrl + path, method: .post, parameters: params, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject {(response: DataResponse<T>) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if response.result.isSuccess {
                    onSuccess(response.value!)
                    return
                }

                onFailure(self.handleError(response: response))
        }
    }

    public func postImage<T: EVObject>(image: UIImage?,
                                       path: String,
                                       params: Parameters? = nil,
                                       onSuccess: @escaping (T) -> Void,
                                       onFailure: @escaping OnFailure) {
        let headers = ["Authorization": "Bearer " + UserDefaults.loadAccessToken()]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        Alamofire
            .upload(multipartFormData: { multipartFormData in
                if let newImage = image {
                    let newImageData = UIImageJPEGRepresentation(self.resizeImage(image: newImage), 0.8)
                    multipartFormData.append(newImageData!,
                                             withName: "imageFile",
                                             fileName: "faceImage.jpg",
                                             mimeType: "image/jpeg")
                }
            }, usingThreshold: UInt64.init(),
               to: Constants.kApiUrl + path,
               method: .post,
               headers: headers,
               encodingCompletion: { encodingResult in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch encodingResult {
                case .success(let upload, _, _):
                    upload
                        .validate()
                        .responseObject {(response: DataResponse<T>) in
                            if response.result.isSuccess {
                                onSuccess(response.result.value!)
                                return
                            }
                            onFailure(self.handleError(response: response))
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            })
    }

    public func put<T: EVObject>(path: String,
                                 params: Parameters? = nil,
                                 onSuccess: @escaping (T) -> Void,
                                 onFailure: @escaping OnFailure) {
        let headers = ["Authorization": "Bearer " + UserDefaults.loadAccessToken()]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        Alamofire
            .request(Constants.kApiUrl + path, method: .put, parameters: params, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject {(response: DataResponse<T>) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if response.result.isSuccess {
                    onSuccess(response.value!)
                    return
                }
                onFailure(self.handleError(response: response))
        }
    }

    private func handleError<T: EVObject>(response: DataResponse<T>) -> ErrorResource {
        if !(response.error! is AFError) {
            let errorResource = ErrorResource()
            errorResource.status = httpStatusNetworkError
            errorResource.message = (response.error?.localizedDescription)!
            return errorResource
        }

        let errorString = String(data: response.data!, encoding: String.Encoding.utf8)!
        let errorResource = ErrorResource(json: errorString)
        let error = response.error as? AFError
        errorResource.status =
            errorResource.status == 0 ?
                error?.responseCode ??
                httpStatusInternalServerError :
            errorResource.status
        errorResource.message = errorResource.message == "" ?
            "Internal Server Error. Please try again." :
            errorResource.message
        return errorResource
    }

    private func resizeImage(image: UIImage) -> UIImage {
        let actualHeight: Float = Float(image.size.height)
        let actualWidth: Float = Float(image.size.width)

        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)

        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData: NSData = UIImageJPEGRepresentation(img, 1.0)! as NSData
        UIGraphicsEndImageContext()
        return UIImage(data: imageData as Data)!
    }
}
