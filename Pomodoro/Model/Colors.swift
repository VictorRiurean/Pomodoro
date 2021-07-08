//
//  Colors.swift
//  Pomodoro
//
//  Created by Victor on 05/07/2021.
//

import UIKit

class Colors {
    static var colors = [UIColor(rgb: 0xcaf7e3), UIColor(rgb: 0xedffec), UIColor(rgb: 0xf6dfeb), UIColor(rgb: 0xe4bad4), UIColor(rgb: 0xfceaea), UIColor(rgb: 0xf5d9d9), UIColor(rgb: 0xfbead1), UIColor(rgb: 0xa6d6d6), UIColor(rgb: 0xededd0)]
    
    static var count = colors.count
    
    static var myGray = UIColor(rgb: 0xe1e5ea)
    
    static var myTextGray = UIColor(rgb: 0x5a5353)
    
    static var myVeryLightGray = UIColor(rgb: 0xF9F9F9)
    
    static var myGreen = UIColor(rgb: 0x1eae98)
    
    static var myOrange = UIColor(rgb: 0xff9500)
    
    static func getColor(index: Int) -> UIColor {
        return colors[index]
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
