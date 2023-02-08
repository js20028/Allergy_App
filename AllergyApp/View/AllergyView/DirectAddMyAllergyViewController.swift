//
//  DirectAddMyAllergyViewController.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/08.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class DirectAddMyAllergyViewController: UIViewController {
    
    @IBOutlet weak var directAllergyTextField: UITextField!
    @IBOutlet weak var directMyAllergyAddButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var totalAllergyViewModel: TotalAllergyViewModel?
    
    let disposeBag = DisposeBag()
    
    var contentViewheight: Double? // content view 높이

    override func viewDidLoad() {
        super.viewDidLoad()
        directAllergyTextField.text = nil
        contentViewheight = contentView.frame.height
        
        
        
        
        directMyAllergyAddButton.rx.tap.bind(onNext: {
            
            if let directAllergytext = self.directAllergyTextField.text {
                let allergies = Allergy(allergyName: directAllergytext, myAllergy: true)
                self.totalAllergyViewModel?.directAddAllergy.onNext(allergies)
                self.dismiss(animated: true)
            } // else가 실행안됨 textfield에 아무것도 안적어도 nil이 아니라 ""로됨

        }).disposed(by: disposeBag)
        
    }
    

}
