//
//  ItemTableCell.swift
//  SXSW
//
//  Created by Stuart Olivera on 3/13/18.
//  Copyright © 2018 Stuart Olivera. All rights reserved.
//

import UIKit

class ItemTableCell : UITableViewCell {

    @IBOutlet weak var wrappingView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        wrappingView.layer.cornerRadius = 8
        wrappingView.layer.masksToBounds = true

        cellImage.layer.cornerRadius = 40;
        cellImage.layer.masksToBounds = true;
    }
}
