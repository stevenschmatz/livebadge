//
//  ItemTableViewController.swift
//  SXSW
//
//  Created by Stuart Olivera on 3/13/18.
//  Copyright © 2018 Stuart Olivera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ItemTableViewController : UITableViewController {

    var ref: DatabaseReference!
    var items: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()

        getData()
    }

    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true)
    }

    func getData() {
        ref.child("events/").observe(.childAdded, with: { (snapshot) -> Void in
            let item = Item(description: snapshot.description, rarity: "")
            self.items.append(item)
            self.tableView.insertRows(at: [IndexPath(row: self.items.count-1, section: 1)], with: UITableViewRowAnimation.automatic)
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableCell
        
        if indexPath.row == 0 {
            cell.title.text = "Marshmello"
            cell.subtitle.text = "20% off all Marshmello merchandise"
            cell.cellImage.image = UIImage(named: "sxsw2018")
            cell.wrappingView.backgroundColor = Colors.Blue
        } else if indexPath.row == 1 {
            cell.title.text = "Westworld"
            cell.subtitle.text = "Westworld Season 1 Collector's Edition"
            cell.cellImage.image = UIImage(named: "sxsw2018")
            cell.wrappingView.backgroundColor = Colors.Orange
        } else {
            cell.title.text = "Ready Player One"
            cell.subtitle.text = "VIP Invitation to Ready Player One Premiere"
            cell.cellImage.image = UIImage(named: "sxsw2018")
            cell.wrappingView.backgroundColor = Colors.Pink
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.present(OfferViewController(rarity: Rarity.Common, offer: "20% off all Marshmello merchandise"), animated: true)
        } else if indexPath.row == 1 {
            self.present(OfferViewController(rarity: Rarity.Rare, offer: "Westworld Season 1 Collector's Edition"), animated: true)
        } else {
            self.present(OfferViewController(rarity: Rarity.Legendary, offer: "VIP Invitation to Ready Player One Premiere"), animated: true)
        }
    }
}
