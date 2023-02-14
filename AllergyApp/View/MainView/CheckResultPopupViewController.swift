//
//  CheckResultPopupViewController.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/14.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class CheckResultPopupViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var checkResultButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dismissButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        
        checkResultButton.rx.tap
            .bind(to: self.viewModel?.checkResultButtonTapped ?? PublishSubject())
            .disposed(by: disposeBag)
        
    }
    
    
    
}
