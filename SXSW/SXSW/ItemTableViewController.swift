//
//  ItemTableViewController.swift
//  SXSW
//
//  Created by Stuart Olivera on 3/13/18.
//  Copyright © 2018 Stuart Olivera. All rights reserved.
//

import UIKit

class ItemTableViewController : UITableViewController {

    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableCell

        cell.title.text = "Marshmallow"
        cell.subtitle.text = "Live at the Garden"
        cell.cellImage.image = UIImage(named: "sxsw2018")

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}
