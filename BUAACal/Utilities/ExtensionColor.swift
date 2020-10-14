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
    Color(UIColor(hexString: "#DFE6E5")),
    Color(UIColor(hexString: "#D4F0D3")),
    Color(UIColor(hexString: "#E8D497")),
    Color(UIColor(hexString: "#EDCB64")),
    Color(UIColor(hexString: "#E2E2B6")),
    Color(UIColor(hexString: "#F1F2C6")),
    Color(UIColor(hexString: "#CC99BE")),
    Color(UIColor(hexString: "#F2FFF3"))
]

public let colorNumbersLight: [Color] = [
    Color(UIColor(hexString: "#93CA76")),
    Color(UIColor(hexString: "#A0D8EF")),
    Color(UIColor(hexString: "#FDDEA5")),
    Color(UIColor(hexString: "#D3CCD6")),
    Color(UIColor(hexString: "#E4AB9B")),
    Color(UIColor(hexString: "#DBD0E6")),
    Color(UIColor(hexString: "#DCDDDD")),
    Color(UIColor(hexString: "#DDBB99"))
]

//public let colorNumbersLight: [Color] = [
//    Color(UIColor(hexString: "#E9EFEF")),
//    Color(UIColor(hexString: "#E2EFF0")),
//    Color(UIColor(hexString: "#BCD8Df")),
//    Color(UIColor(hexString: "#F8F6E6")),
//    Color(UIColor(hexString: "#F1CFD5")),
//    Color(UIColor(hexString: "#E2E5EF")),
//    Color(UIColor(hexString: "#D5D4D8")),
//    Color(UIColor(hexString: "#D0E1D7"))
//]
