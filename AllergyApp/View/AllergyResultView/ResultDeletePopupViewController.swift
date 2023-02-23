//
//  ResultDeletePopupViewController.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class ResultDeletePopupViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: LoadAllergyDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .do(onNext: {
                guard let pvc = self.presentingViewController else { return }
                self.dismiss(animated: true) {
                    pvc.dismiss(animated: false, completion: nil)
                }
            })
            .bind(to: viewModel?.deleteButtonTapped ?? PublishSubject())
            .disposed(by: disposeBag)
    }
}
