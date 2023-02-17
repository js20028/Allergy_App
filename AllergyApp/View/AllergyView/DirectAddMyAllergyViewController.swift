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
    @IBOutlet weak var textStatusLabel: UILabel!
    @IBOutlet weak var directMyAllergyAddButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var totalAllergyViewModel: TotalAllergyViewModel?
    
    let disposeBag = DisposeBag()
    
    var contentViewheight: Double? // content view 높이

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentViewheight = contentView.frame.height
        
        textStatusLabel.text = "알러지를 적어주세요"
        
        
        let allergyValid = directAllergyTextField.rx.text.orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).count > 0}
            .share(replay: 1) //
        
        
        allergyValid
            .bind(to: textStatusLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        allergyValid
            .bind(to: directMyAllergyAddButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        directMyAllergyAddButton.rx.tap.bind(onNext: {
            // textfield.text 앞과 뒤의 공백을 없애줌 + 빈값인지 확인
            if let directAllergyText = self.directAllergyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !directAllergyText.isEmpty {
                let allergyExists = self.totalAllergyViewModel?.totalAllergy.value.contains(where: { $0.allergyName == directAllergyText }) ?? false
                
                if allergyExists {
                    print("이미 존재하는 알러지")
                    DispatchQueue.main.async {
                        self.textStatusLabel.text = "이미 있는 알러지 입니다."
                    }
                    
                } else {
                    let allergies = Allergy(allergyName: directAllergyText, myAllergy: true)
                    self.totalAllergyViewModel?.directAddAllergy.onNext(allergies)
                    self.dismiss(animated: true)
                }
            } else {
                print("?")
            }
        })
        .disposed(by: disposeBag)
        
        
        dismissButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
    }
    

}
