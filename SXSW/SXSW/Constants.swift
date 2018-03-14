//
//  Constants.swift
//  SXSW
//
//  Created by Steven Schmatz on 3/13/18.
//  Copyright © 2018 Stuart Olivera. All rights reserved.
//

import UIKit
import Foundation

struct Colors {
    static let Blue = UIColor(red: 31/255.0, green: 214/255.0, blue: 255/255.0, alpha: 1)
    static let Pink = UIColor(red: 245/255.0, green: 113/255.0, blue: 209/255.0, alpha: 1)
    static let Orange = UIColor(red: 242/255.0, green: 145/255.0, blue: 32/255.0, alpha: 1)
}

// https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

// https://stackoverflow.com/questions/39802420/change-status-bar-background-color-in-swift-3/39802582
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

// https://stackoverflow.com/questions/39624675/add-shadow-on-uiview-using-swift-3
extension UIView {
    func dropShadow(offsetX: CGFloat, offsetY: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
