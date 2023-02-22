//
//  LoadAllergyDetailViewController.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/01/24.
//

import UIKit
import RxSwift
import RxCocoa

class LoadAllergyDetailViewController: UIViewController {
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productIngredientTextView: UITextView!
    @IBOutlet weak var productAllergyTextView: UITextView!
    @IBOutlet weak var allergyResultTextView: UITextView!
    
    var disposeBag = DisposeBag()
    var viewModel: LoadAllergyDetailViewModel
    
    init(viewModel: LoadAllergyDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = LoadAllergyDetailViewModel(AllergyResult(date: Date(), productName: "", productIngredient: "", productAllergy: "", compareResult: ""))
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productIngredientTextView.delegate = self
        productAllergyTextView.delegate = self
        allergyResultTextView.delegate = self
        
        productIngredientTextView.textContainerInset = .init(top: 15, left: 10, bottom: 0, right: 10)
        productAllergyTextView.textContainerInset = .init(top: 15, left: 10, bottom: 0, right: 10)
        
        bindUI()
    }
    
    private func bindUI() {
        viewModel.createDateText
            .bind(to: self.createDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.productNameText
            .bind(to: self.productNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.productIngredientText
            .bind(to: self.productIngredientTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.productAllergyText
            .bind(to: self.productAllergyTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.allergyResultText
            .bind(to: self.allergyResultTextView.rx.text)
            .disposed(by: disposeBag)
        
        self.dismissButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        self.deleteButton.rx.tap
            .do(onNext: {
                self.dismiss(animated: true)
            })
            .bind(to: viewModel.deleteButtonTapped)
            .disposed(by: disposeBag)
        
    }
}

// MARK: 텍스트 뷰 수정x
extension LoadAllergyDetailViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }

}
