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
    
    @IBOutlet weak var scanResultTitleLabel: UILabel!
    @IBOutlet weak var scanResultContentLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var checkResultButton: UIButton!
    
    @IBOutlet weak var popupView: UIView!
    
    let disposeBag = DisposeBag()
    var viewModel: MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 10
        checkResultButton.layer.cornerRadius = 10
        
        viewModel?.popupTitleText
            .bind(to: self.scanResultTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.popupContentText
            .bind(to: self.scanResultContentLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.popupCheckResultButtonIsHidden
            .bind(to: self.checkResultButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        dismissButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        checkResultButton.rx.tap
            .do(onNext: {
                print("팝업 디스미스")
            })
            .bind(to: self.viewModel?.checkResultButtonTapped ?? PublishSubject())
            .disposed(by: disposeBag)
        
        viewModel?.resultSubject
            .bind(onNext: {
                print("resultSubject 바인드~~~~~~~~~~~~~~~~~~~~~")
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                guard let scanResultVC = storyboard.instantiateViewController(withIdentifier: "ScanResultViewController") as? ScanResultViewController else { return }
                print(scanResultVC, "스캔결과 뷰컨트롤러")
                let viewModel = ScanResultViewModel(result: $0)
                scanResultVC.viewModel = viewModel
                
                scanResultVC.modalPresentationStyle = .fullScreen
                
                guard let pvc = self.presentingViewController else { return }
                
                self.dismiss(animated: true) {
                            pvc.present(scanResultVC, animated: false, completion: nil)
                        }
            })
            .disposed(by: disposeBag)
        
    }
}
