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
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
}

public let colorNumbers: [Color] = [
    Color(UIColor(hexString: "#6A755C")),
    Color(UIColor(hexString: "#9790A4")),
    Color(UIColor(hexString: "#6E798C")),
    Color(UIColor(hexString: "#87544A")),
    Color(UIColor(hexString: "#3C6869")),
    Color(UIColor(hexString: "#25556B")),
    Color(UIColor(hexString: "#6080A0")),
    Color(UIColor(hexString: "#948365"))
]

public let colorNumbersLight: [Color] = [
    Color(UIColor(hexString: "#93CA76")),
    Color(UIColor(hexString: "#A69ABD")),
    Color(UIColor(hexString: "#C1D8AC")),
    Color(UIColor(hexString: "#A0CED8")),
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
