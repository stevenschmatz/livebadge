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

        wrappingView.dropShadow(offsetX: 0, offsetY: 20, color: UIColor(hue: 0, saturation: 0, brightness: 0.43, alpha: 1), opacity: 0.36, radius: 10)

        cellImage.layer.cornerRadius = 40;
        cellImage.layer.masksToBounds = true;
    }
}
