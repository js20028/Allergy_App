//
//  ViewController.swift
//  AllergyApp
//
//  Created by 곽재선 on 2022/05/29.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

class MainViewController: UIViewController {
    
    @IBOutlet weak var registerAllergyButton: UIButton!
    @IBOutlet weak var loadAllergyButton: UIButton!
    @IBOutlet weak var barcodeScanButton: UIButton!
    @IBOutlet weak var barcodeView: BarcodeView!
    
    let viewModel: MainViewModel
    
    let disposeBag = DisposeBag()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = MainViewModel(allergyModel: AllergyModel(), fetchBarcodeInfo: FetchBarcodeInfo(), fetchProductInfo: FetchProductInfo())
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.barcodeView.delegate = self
        
        // 알러지 등록 버튼 클릭
        registerAllergyButton.rx.tap
            .bind(onNext: {
                let showAllergyStoryboard = UIStoryboard.init(name: "ShowAllergy", bundle: nil)
                
                guard let myAllergyViewController = showAllergyStoryboard.instantiateViewController(withIdentifier: "MyAllergyViewController") as? MyAllergyViewController else { return }
                myAllergyViewController.modalPresentationStyle = .fullScreen
                
                self.present(myAllergyViewController, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        
        
        // 알러지 불러오기 버튼 클릭
        loadAllergyButton.rx.tap
            .bind(onNext: {
                guard let loadAllergyVC = self.storyboard?.instantiateViewController(withIdentifier: "LoadAllergyViewController") as? LoadAllergyViewController else { return }
                
                loadAllergyVC.modalPresentationStyle = .fullScreen
                self.present(loadAllergyVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        
//         바코드 스캔 버튼 클릭
        barcodeScanButton.rx.tap
            .do(onNext: {
                self.view.hideToast()
                self.view.makeToast("바코드를 가운데 선에 맞춰주세요", duration: 1.5, position: .center)
            
                self.barcodeView.start()
            })
            .bind(to: viewModel.scanButtonTapped)
            .disposed(by: disposeBag)

    }

}


extension MainViewController: ReaderViewDelegate {
    func readerComplete(status: ReaderStatus) {
        
        switch status {
        case let .success(code):
            print(code,"코드")
            
            if let code = code {
                viewModel.barcodeSubject.onNext(code)
                
                let checkResultPopup = CheckResultPopupViewController(nibName: "CheckResultPopup", bundle: nil)
                
                checkResultPopup.modalPresentationStyle = .overCurrentContext
                checkResultPopup.modalTransitionStyle = .crossDissolve // 뷰가 투명해지면서 넘어가는 애니메이션
                checkResultPopup.viewModel = self.viewModel
                
                viewModel.popupTitleText.onNext("스캔 성공")
                viewModel.popupContentText.onNext("결과를 확인하시겠습니까?")
                viewModel.popupCheckResultButtonIsHidden.onNext(false)
                
                self.present(checkResultPopup, animated: false, completion: nil)
            }
            
        case .fail:
            print("실패")
            
        case let .stop(isButtonTap):
            print("스탑")
        }
        
    }
}
