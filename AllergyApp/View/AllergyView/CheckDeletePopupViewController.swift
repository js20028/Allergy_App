//
//  CheckDeletePopupViewController.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/21.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

enum allergyViewStatus {
    case totalAllergy
    case myAllergy
}

class CheckDeletePopupViewController: UIViewController {
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var popupContentLabel: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var allergyViewStatus: allergyViewStatus?
    var totalAllergyViewModel: TotalAllergyViewModel?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 20
        
        self.configureButton()
        self.configurePopupView()
        
        deleteButton.rx.tap.bind(onNext: {
            
            if self.allergyViewStatus == .myAllergy {
                print("마이")
                self.totalAllergyViewModel?.tapdelete.onNext(self.totalAllergyViewModel?.checkMyAllergy.value ?? [])
            } else {
                print("토탈")
                self.totalAllergyViewModel?.tapTotaldelete.onNext(self.totalAllergyViewModel?.checkAllergy.value ?? [])
            }
            
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        
        dismissButton.rx.tap.bind(onNext: {
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        
        
    }
}

extension CheckDeletePopupViewController {
    func configureButton() {
        self.dismissButton.layer.cornerRadius = 10
        self.deleteButton.layer.cornerRadius = 10
        self.popUpView.layer.cornerRadius = 20
        self.popupTitleLabel.font = UIFont(name: "NanumSquareEB", size: 19.0)
    }
    
    func configurePopupView() {
        
    }
    
    func configureLabel() {
        
    }
}
