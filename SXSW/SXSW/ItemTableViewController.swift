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

let colors = [
    Rarity.Common: Colors.Blue,
    Rarity.Rare: Colors.Orange,
    Rarity.Legendary: Colors.Pink
]

let mapping = [Rarity.Common, Rarity.Rare, Rarity.Legendary]

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
        ref.child("users").child("vMTuRtY4OYN3h3cpAArm9fEAj8y1").child("event").child("4").observe(.childAdded, with: { (snapshot) -> Void in
            let value = snapshot.value as? NSDictionary? ?? [:]
            let title = value?["name"] as? String ?? ""
            let description = value?["description"] as? String ?? ""
            let item = Item(title: title, description: description)
            self.items.append(item)
            self.tableView.insertRows(at: [IndexPath(row: self.items.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableCell

        let item = self.items[indexPath.row]
        
        cell.title.text = item.title
        cell.subtitle.text = item.description
        cell.cellImage.image = UIImage(named: "sxsw2018")
        let rarity = mapping[indexPath.row % 3]
        cell.wrappingView.backgroundColor = colors[rarity]
//        } else if indexPath.row == 1 {
//            cell.title.text = "Westworld"
//            cell.subtitle.text = "Westworld Season 1 Collector's Edition"
//            cell.cellImage.image = UIImage(named: "sxsw2018")
//            cell.wrappingView.backgroundColor = Colors.Orange
//        } else {
//            cell.title.text = "Ready Player One"
//            cell.subtitle.text = "VIP Invitation to Ready Player One Premiere"
//            cell.cellImage.image = UIImage(named: "sxsw2018")
//            cell.wrappingView.backgroundColor = Colors.Pink
//        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rarity = mapping[indexPath.row % 3]
        let item = self.items[indexPath.row]

        self.present(OfferViewController(rarity: rarity, offer: item.description), animated: true)
    }
}
