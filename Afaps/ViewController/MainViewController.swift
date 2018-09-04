//
//  MainViewController.swift
//  Afaps-enterprise
//
//  Created by Jiraporn Praneet on 6/9/2561 BE.
//  Copyright © 2561 InformatixPlusCompanyLimited. All rights reserved.
//

import UIKit
import SSPullToRefresh
import SDWebImage

class MainTableViewCell: UITableViewCell {
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var similarityLabel: UILabel!
    @IBOutlet var faceImageView: UIImageView!
}

class MainViewController: UIViewController, SSPullToRefreshViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    var pullToRefreshView: SSPullToRefreshView!
    var faceResources = [FaceResource]()

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        pullToRefreshView = SSPullToRefreshView(scrollView: tableView, delegate: self)
        pullToRefreshView.startLoadingAndExpand(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        getAllFace()
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

    func getAllFace() {
        FaceManager().getFace(onSuccess: { (resource) in
            self.pullToRefreshView.finishLoading()
            self.faceResources = resource
            print("face\(self.faceResources)")
            self.tableView.reloadData()
        }, onFailure: { errorResource in
            self.pullToRefreshView.finishLoading()
            ErrorResult().showError(errorResource: errorResource, viewController: self)
        })
    }

    func pull(toRefreshViewDidStartLoading view: SSPullToRefreshView!) {
        pullToRefreshView.startLoading()
        getAllFace()
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
