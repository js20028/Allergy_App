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
        
    }
}
