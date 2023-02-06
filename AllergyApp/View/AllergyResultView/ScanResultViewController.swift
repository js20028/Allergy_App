//
//  ScanResultViewController.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/02/01.
//

import UIKit
import RxSwift
import RxCocoa

class ScanResultViewController: UIViewController {
    
    @IBOutlet weak var scanResultSaveButton: UIBarButtonItem!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productIngredientTextView: UITextView!
    @IBOutlet weak var allergyResultTextView: UITextView!
    
    var disposeBag = DisposeBag()
    var viewModel: ScanResultViewModel
    
    init(viewModel: ScanResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = ScanResultViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
    private func bindUI() {
        viewModel.productNameText
            .bind(to: self.productNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.productIngredientText
            .bind(to: self.productIngredientTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.allergyResultText
            .bind(to: self.allergyResultTextView.rx.text)
            .disposed(by: disposeBag)
        
        self.scanResultSaveButton.rx.tap
            .do(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .bind(to: viewModel.saveButtonTapped)
            .disposed(by: disposeBag)
    }
}
