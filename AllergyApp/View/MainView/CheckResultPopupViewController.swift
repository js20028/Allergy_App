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
import Lottie

class CheckResultPopupViewController: UIViewController {
    
    @IBOutlet weak var scanResultTitleLabel: UILabel!
    @IBOutlet weak var scanResultContentLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var checkResultButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var lottieIndicatorView: LottieAnimationView!
    
    var lottieView: LottieAnimationView? = nil
    
    let disposeBag = DisposeBag()
    var viewModel: MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = viewModel else { return }

        
        self.lottieView = playLottieAnimationView()
        self.configureUI()
        
        viewModel.popupTitleText
            .bind(to: self.scanResultTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.popupContentText
            .bind(to: self.scanResultContentLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.popupCheckResultButtonIsHidden
            .bind(to: self.checkResultButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        dismissButton.rx.tap
            .bind(onNext: { [weak self] in
                

                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        checkResultButton.rx.tap
            .do(onNext: { [weak self] in
                guard let self = self else {return}
                self.showIndicatorView()
                self.lottieView?.play()
                print("팝업 디스미스")
                print(viewModel.checkResultButtonTapped,"체크리절트텝드")
            })
            .bind(to: viewModel.checkResultButtonTapped ?? PublishSubject())
            .disposed(by: disposeBag)
        
//        viewModel?.resultSubject
//            .subscribe(onNext: {
//                print("resultSubject 바인드~~~~~~~~~~~~~~~~~~~~~")
//                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                guard let scanResultVC = storyboard.instantiateViewController(withIdentifier: "ScanResultViewController") as? ScanResultViewController else { return }
//                print(scanResultVC, "스캔결과 뷰컨트롤러")
//                let viewModel = ScanResultViewModel(result: $0)
//                scanResultVC.viewModel = viewModel
//
//                scanResultVC.modalPresentationStyle = .fullScreen
//
//                guard let pvc = self.presentingViewController else { return }
//                self.hideIndicatorView()
//                self.lottieView?.stop()
//                self.dismiss(animated: true) {
//                            pvc.present(scanResultVC, animated: false, completion: nil)
//                    self.hideIndicatorView()
//                    self.lottieView?.stop()
//                        }
//            }, onError: { error in
//                print(error,"에에에러러러")
//                self.hideIndicatorView()
//                self.lottieView?.stop()
//            })
//            .disposed(by: disposeBag)
                
                viewModel.checkNextOrError.bind(onNext: { [weak self] status in
                    guard let self = self else {return}
                    
                    if status == .success {
                        self.viewModel?.resultSubject
                            .subscribe(onNext: { [weak self] re in
                                guard let self = self else {return}
                                print("\(re)  resultSubject 바인드~~~~~~~~~~~~~~~~~~~~~")
                                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                guard let scanResultVC = storyboard.instantiateViewController(withIdentifier: "ScanResultViewController") as? ScanResultViewController else { return }
                                print(scanResultVC, "스캔결과 뷰컨트롤러")
                                let viewModel = ScanResultViewModel(result: re)
                                scanResultVC.viewModel = viewModel
                                
                                scanResultVC.modalPresentationStyle = .fullScreen
                                
                                guard let pvc = self.presentingViewController else { return }
                                
                                self.dismiss(animated: true, completion: {
                                    pvc.present(scanResultVC, animated: false, completion: nil)
                                    self.lottieView?.stop()
                                    self.hideIndicatorView()
                                   
                                })
                            }).disposed(by: self.disposeBag)
                        
                        
                    } else if status == .fail {
                        print("펄스")
                        self.lottieView?.stop()
                        self.hideIndicatorView()
                        
                    } else {
                        
                        print("닐", Unmanaged.passUnretained(self).toOpaque())
                    }
                }).disposed(by: disposeBag)
        
    }
    
    deinit {
            print("PopupViewController is deallocated.")
        }
}

extension CheckResultPopupViewController {
    
    func configureUI() {
        scanResultTitleLabel.font = UIFont(name: "NanumSquareEB", size: 20.0)
        popupView.layer.cornerRadius = 20
        checkResultButton.layer.cornerRadius = 15
        dismissButton.layer.cornerRadius = 15
    }
    
    func showIndicatorView() {
        print("indicator 실행")
        self.dismissButton.isUserInteractionEnabled = false
        self.checkResultButton.isUserInteractionEnabled = false
        
        self.lottieIndicatorView?.isHidden = false
        
    }
    
    func hideIndicatorView() {
        self.dismissButton.isUserInteractionEnabled = true
        self.checkResultButton.isUserInteractionEnabled = true
        self.lottieIndicatorView?.isHidden = true
    }
    
    
    private func playLottieAnimationView() -> LottieAnimationView {
        let animationView: LottieAnimationView = .init(name: "indicator3")
//
//        lottieIndicatorView.contentMode = .scaleAspectFit
        lottieIndicatorView.addSubview(animationView)
        
        animationView.frame = lottieIndicatorView.bounds
        animationView.loopMode = .loop
        return animationView
    }
}
