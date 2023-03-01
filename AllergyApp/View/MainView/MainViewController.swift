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
import Lottie

enum showLabel: Codable {
    case show
    case hide
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var showDescriptionButton: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionBarcodeLabel: UILabel!
    @IBOutlet weak var descriptionMenuLabel: UILabel!
    @IBOutlet weak var registerAllergyButton: UIButton!
    @IBOutlet weak var loadAllergyButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var barcodeView: BarcodeView!
    @IBOutlet weak var showLabelButton: UIButton!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var logoLabel: UILabel!
    
    let viewModel: MainViewModel
    
    let disposeBag = DisposeBag()
    var showAlert: showLabel = .hide
    var showDescription: showLabel?
    
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
        
        self.showDescription = UserDefault().loadUserDefault()
        descriptionView.isHidden = showDescription == .hide ? true : false
        showDescriptionButton.tintColor = showDescription == .hide ? UIColor.veryLightGrey : UIColor.primaryColor
        
        self.logoLabel.font = UIFont(name: "Cafe24Ssurround", size: 24.0)
        
        self.descriptionMenuLabel.font = UIFont(name: "NanumSquareEB", size: 21.0)
        self.descriptionBarcodeLabel.font = UIFont(name: "NanumSquareEB", size: 21.0)
        
        
        let tapGesture = UITapGestureRecognizer()
        barcodeView.addGestureRecognizer(tapGesture)
        
        let tapDescription = UITapGestureRecognizer()
        descriptionView.addGestureRecognizer(tapDescription)
        
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
        
        tapDescription.rx.event
            .map { _ in print("바코드뷰 클릭") }
            .bind(onNext: {
                self.descriptionView.isHidden = true
                self.showDescription = .hide
                self.viewModel.descriptionStatus.accept(.hide)
                self.showDescriptionButton.tintColor = UIColor.veryLightGrey
            })
            .disposed(by: disposeBag)
        
        
        // 바코드 뷰 클릭
        tapGesture.rx.event
            .map { _ in print("바코드뷰 클릭") }
            .do(onNext: { _ in
                self.view.hideToast()
                self.view.makeToast("바코드를 가운데 선에 맞춰주세요", duration: 1.5, position: .center)
                self.barcodeView.start()
            })
            .bind(to: viewModel.scanButtonTapped)
            .disposed(by: disposeBag)
                
                
        showDescriptionButton.rx.tap
            .bind(onNext: {
                if self.showDescription == .hide {
                    self.descriptionView.isHidden = false
                    self.showDescriptionButton.tintColor = UIColor.primaryColor
                    self.showDescription = .show
                } else {
                    self.descriptionView.isHidden = true
                    self.showDescriptionButton.tintColor = UIColor.veryLightGrey
                    self.showDescription = .hide
                }
            })
            .disposed(by: disposeBag)
        
                
        showLabelButton.rx.tap.bind(onNext: {
            
            UIView.animate(withDuration: 0.1, animations: {
                if self.showAlert == .hide {
                    self.showLabel.isHidden = false
                    self.showLabelButton.tintColor = UIColor.primaryColor
                    self.showAlert = .show
                } else {
                    self.showLabel.isHidden = true
                    self.showLabelButton.tintColor = UIColor.veryLightGrey
                    self.showAlert = .hide
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
