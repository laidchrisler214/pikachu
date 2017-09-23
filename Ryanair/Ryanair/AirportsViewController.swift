//
//  AirportsViewController.swift
//  Ryanair
//
//  Created by GreatFeat on 22/09/2017.
//  Copyright © 2017 Ariel. All rights reserved.
//

import UIKit
import PKHUD

class AirportsViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var revealerMap: UIBarButtonItem!

    //MARK: PROPERTIES
    var airports = [AirportModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            revealerMap.target = self.revealViewController()
            revealerMap.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rightViewRevealWidth = self.view.frame.size.width * 0.85
        }
        getAirport()
    }

    //MARK: API
    func getAirport() {
        LoadingView.retrievingProgress()
        let request = AirportRequestManager()
        request.getAirportsData(completionHandler: { (airports) in
            LoadingView.hide()
            self.airports = airports
            self.tableView.reloadData()
        }) { (error) in
            LoadingView.hide()
            self.showAlert(error: error as! String)
        }
    }

    //MARK: HELPER
    func showAlert(error: String) {
        let alert = UIAlertController(title: error, message: "", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension AirportsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.airports.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "AirportTableCell", for: indexPath) as! AirportTableCell
        tableCell.setCell(data: self.airports[indexPath.row])
        return tableCell
    }
}
