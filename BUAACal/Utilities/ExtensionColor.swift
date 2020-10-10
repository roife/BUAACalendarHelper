//
//  ExtensionColor.swift
//  BUAACal
//
//  Created by roife on 10/3/20.
//

import Foundation
import SwiftUI

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.currentIndex = scanner.string.index(after: scanner.string.startIndex)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}


public enum EventCardColor: Int {
    case purplePunch = 0
    case tangyOrange
    case placidGreen
    case brightYellow
    case trendyTeal
    case gleamyPink
    case beamingBlue
    case vanillaIce
}

public let colorNumbers: [Color] = [
    Color(UIColor(hexString: "#D4DFE6")),
    Color(UIColor(hexString: "#7EB0D4")),
    Color(UIColor(hexString: "#A5E17C")),
    Color(UIColor(hexString: "#FFDE41")),
    Color(UIColor(hexString: "#71EFBA")),
    Color(UIColor(hexString: "#EF7CE4")),
    Color(UIColor(hexString: "#84DBEE")),
    Color(UIColor(hexString: "#F5E0E0"))
]

public let colorNumbersLight: [Color] = [
    Color(UIColor(hexString: "#C5E99B")),
    Color(UIColor(hexString: "#D4DFE6")),
    Color(UIColor(hexString: "#B7F48D")),
    Color(UIColor(hexString: "#FFEA85")),
    Color(UIColor(hexString: "#84FFCB")),
    Color(UIColor(hexString: "#FF94F4")),
    Color(UIColor(hexString: "#9FEEFF")),
    Color(UIColor(hexString: "#F8EBEB"))
]
