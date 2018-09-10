//
//  MainViewController.swift
//  Afaps-enterprise
//
//  Created by Jiraporn Praneet on 6/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import UIKit
import SDWebImage
import Messages
import Firebase

class MainTableViewCell: UITableViewCell {
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var similarityLabel: UILabel!
    @IBOutlet var faceImageView: UIImageView!
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    var refresher: UIRefreshControl!
    var faceResources = [FaceResource]()
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: .zero)
        timer = Timer.scheduledTimer(timeInterval: 5,
                                     target: self,
                                     selector: #selector(sendFCMToken),
                                     userInfo: nil,
                                     repeats: true)
        sendFCMToken()
        getAllFace()
        addRefreshControl()
    }

    func addRefreshControl() {
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.gray
        refresher.addTarget(self, action: #selector(getAllFace), for: .valueChanged)
        tableView.refreshControl = refresher
    }

    // MARK: FCM
    @objc func sendFCMToken() {
        if let registrationToken = UserDefaults.loadFCMToken() {
            let request = FCMInstantIDTokenRequest()
            request.registrationToken = registrationToken

            FCMManager().postFCMInstantIDToken(registrationToken: request.registrationToken!, onSuccess: { (_) in
                self.timer.invalidate()
            }, onFailure: { (errorResource) in
                self.timer.invalidate()
                ErrorResult().showError(errorResource: errorResource, viewController: self)
            })
        }
    }

    // MARK: IBAction
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil,
                                      message: R.string.localizable.doYouWantToLogOut(),
                                      preferredStyle: UIAlertControllerStyle.alert)

        let okAction = UIAlertAction(title: R.string.localizable.confirm(),
                                     style: UIAlertActionStyle.destructive) { _ in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:
                notificationNamePresentLoginView),
                                            object: nil)
        }

        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: R.string.localizable.cancel(),
                                      style: UIAlertActionStyle.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func getAllFace() {
        FaceManager().getFace(onSuccess: { (resource) in
            self.refresher.endRefreshing()
            self.faceResources = resource
            self.tableView.reloadData()
        }, onFailure: { errorResource in
            self.refresher.endRefreshing()
            ErrorResult().showError(errorResource: errorResource, viewController: self)
        })
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfSections: Int = 0
        if faceResources.count > 0 {
            tableView.separatorStyle = .singleLine
            numOfSections = faceResources.count
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0,
                                                             y: 0,
                                                             width: tableView.bounds.size.width,
                                                             height: tableView.bounds.size.height))
            noDataLabel.text = R.string.localizable.resultNotFound()
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.faceCells,
                                                 for: indexPath as IndexPath)!
        let cellData = faceResources[indexPath.row]
        cell.createdAtLabel.text = R.string.localizable.createdAt((cellData.createdAt?.toLongString())!)
        cell.locationLabel.text = R.string.localizable.location(cellData.location!)
        cell.similarityLabel.text = R.string.localizable.similarity(cellData.similarity!)
        let imageWidth = Int32(cell.faceImageView.frame.size.width * 2)
        let imageHeight = Int32(cell.faceImageView.frame.size.height * 2)
        let imageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: cellData.imageUrl!,
                                                                  width: imageWidth,
                                                                  height: imageHeight)
        cell.faceImageView.sd_setImage(with: imageUrl as URL, completed: nil)
        cell.layoutIfNeeded()
        return cell
    }

}
