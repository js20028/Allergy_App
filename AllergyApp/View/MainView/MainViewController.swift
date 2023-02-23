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

enum showLabel {
    case show
    case hide
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var registerAllergyButton: UIButton!
    @IBOutlet weak var loadAllergyButton: UIButton!
    @IBOutlet weak var barcodeScanButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var barcodeView: BarcodeView!
    @IBOutlet weak var showLabelButton: UIButton!
    @IBOutlet weak var showLabel: UILabel!
    
    let viewModel: MainViewModel
    
    let disposeBag = DisposeBag()
    var showAlert: showLabel = .hide
    
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
        
        
        let tapGesture = UITapGestureRecognizer()
        barcodeView.addGestureRecognizer(tapGesture)
        
        self.configureMenuView()
        
        // 알러지 등록 버튼 클릭
        registerAllergyButton.rx.tap
            .bind(onNext: {
                let showAllergyStoryboard = UIStoryboard.init(name: "ShowAllergy", bundle: nil)
                
                guard let myAllergyViewController = showAllergyStoryboard.instantiateViewController(withIdentifier: "MyAllergyViewController") as? MyAllergyViewController else { return }
                myAllergyViewController.modalPresentationStyle = .fullScreen
                
                self.present(myAllergyViewController, animated: true, completion: nil)
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
//        barcodeScanButton.rx.tap
//            .do(onNext: {
//                self.view.hideToast()
//                self.view.makeToast("바코드를 가운데 선에 맞춰주세요", duration: 1.5, position: .center)
//
//                self.barcodeView.start()
//            })
//            .bind(to: viewModel.scanButtonTapped)
//            .disposed(by: disposeBag)

        tapGesture.rx.event
            .map { _ in print("바코드뷰 클릭") }
            .do(onNext: { _ in
                self.view.hideToast()
                self.view.makeToast("바코드를 가운데 선에 맞춰주세요", duration: 1.5, position: .center)
                self.barcodeView.start()
            })
            .bind(to: viewModel.scanButtonTapped)
            .disposed(by: disposeBag)
                
                
        
                
        showLabelButton.rx.tap.bind(onNext: {
            
            UIView.animate(withDuration: 0.1, animations: {
                if self.showAlert == .show {
                    self.showLabel.isHidden = false
                    self.showLabelButton.tintColor = UIColor.primaryColor
                    self.showAlert = .hide
                } else {
                    self.showLabel.isHidden = true
                    self.showLabelButton.tintColor = UIColor.veryLightGrey
                    self.showAlert = .show
                }
            })
            
        }).disposed(by: disposeBag)

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


extension MainViewController {
    
    func configureMenuView() {
        self.menuView.layer.cornerRadius = 10
        menuView.layer.shadowColor = UIColor.primaryCGColor // 색깔
        menuView.layer.shadowColor = UIColor.black.cgColor // 색깔
        menuView.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        menuView.layer.shadowOffset = CGSize(width: 0, height: 5) // 위치조정
        menuView.layer.shadowRadius = 10 // 반경
        menuView.layer.shadowOpacity = 0.5 // alpha값
    }
}
