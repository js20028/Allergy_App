//
//  Extension.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/20.
//

import Foundation
import UIKit

extension UIColor {
    class var primaryColor: UIColor? { return UIColor(named: "primaryColor") }
    class var primaryCGColor: CGColor { return UIColor.primaryColor!.cgColor }
    
    class var veryLightGrey: UIColor? { return UIColor(named: "veryLightGrey") }
    class var veryLightGreyCGColor: CGColor { return UIColor.veryLightGrey!.cgColor }
}
