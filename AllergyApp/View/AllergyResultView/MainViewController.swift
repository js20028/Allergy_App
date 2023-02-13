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
    @IBOutlet weak var barcodeScanButton: UIButton!

    let viewModel: MainViewModel
    
    let disposeBag = DisposeBag()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = MainViewModel(fetchBarcodeInfo: FetchBarcodeInfo(), fetchProductInfo: FetchProductInfo())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerAllergyButton.rx.tap
            .bind(onNext: {
                let showAllergyStoryboard = UIStoryboard.init(name: "ShowAllergy", bundle: nil)
                
                guard let myAllergyViewController = showAllergyStoryboard.instantiateViewController(withIdentifier: "MyAllergyViewController") as? MyAllergyViewController else { return }
                
                self.present(myAllergyViewController, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        
        barcodeScanButton.rx.tap
            .bind(to: viewModel.scanButtonTapped)
            .disposed(by: disposeBag)
        
    }
    
    
    
}

