//
//  ViewController.swift
//  AllergyApp
//
//  Created by 곽재선 on 2022/05/29.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var registerAllergyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerAllergyButton.rx.tap
            .bind(onNext: {
                let showAllergyStoryboard = UIStoryboard.init(name: "ShowAllergy", bundle: nil)
                
                guard let myAllergyViewController = showAllergyStoryboard.instantiateViewController(withIdentifier: "MyAllergyViewController") as? MyAllergyViewController else { return }
                
                self.present(myAllergyViewController, animated: false, completion: nil)
            })
        
    }
    
    
    
}

