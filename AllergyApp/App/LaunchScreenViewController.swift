//
//  LaunchScreen.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/03/01.
//

import Foundation
import UIKit

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var logoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoLabel.font = UIFont(name: "Cafe24Ssurround", size: 41)
    }
    
}
