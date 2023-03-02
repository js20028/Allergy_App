//
//  myAllergyViewController.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/01/31.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MaterialComponents.MaterialBottomSheet

class MyAllergyViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var deleteMyAllergyButton: UIButton!
    @IBOutlet weak var addMyAllergyButton: UIButton!
    @IBOutlet weak var myAllergyTableView: UITableView!
    @IBOutlet weak var directAddMyAllergyButton: UIButton!
    @IBOutlet weak var allCheckButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var opacityView: UIView!
    
    
    let totalAllergyViewModel: TotalAllergyViewModel
    
    let disposeBag = DisposeBag()
    
    init(totalAllergyViewModel: TotalAllergyViewModel) {
        self.totalAllergyViewModel = totalAllergyViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.totalAllergyViewModel = TotalAllergyViewModel(allergyModel: AllergyModel())
        super.init(coder: coder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer()
        self.opacityView.addGestureRecognizer(tapGesture)
        
        self.congigureAddButton()
        
        let tableViewNibName = UINib(nibName: "ShowAllergyTableViewCell", bundle: nil)
        myAllergyTableView.register(tableViewNibName, forCellReuseIdentifier: "ShowAllergyTableViewCell")
        
        // tableview bind
        totalAllergyViewModel.checkMyAllergy.bind(to: myAllergyTableView.rx.items(cellIdentifier: "ShowAllergyTableViewCell", cellType: ShowAllergyTableViewCell.self )) { (index, model, cell) in
            
            cell.allergyTitleLabel.text = model.allergyName
            cell.checkAllergyImageView.isHidden = model.myAllergy
        }
        .disposed(by: disposeBag)
        
        
        
        // cell 클릭
        myAllergyTableView.rx.itemSelected.bind(onNext: { indexPath in
            self.myAllergyTableView.deselectRow(at: indexPath, animated: false)
            
            let cell = self.myAllergyTableView.cellForRow(at: indexPath) as! ShowAllergyTableViewCell
            cell.selectionStyle = .none // 회색으로 바뀌는 cell 선택 스타일 none으로 변경
            cell.checkAllergyImageView.isHidden = !cell.checkAllergyImageView.isHidden // 선택시 체크 이미지 isHiddden속성 변경
            

            self.totalAllergyViewModel.tapMyAllergyCell.onNext((indexPath.row, cell.checkAllergyImageView.isHidden))
            
            print("my Allergy에서 클릭된 cell의 index: \(indexPath.row), \(!cell.checkAllergyImageView.isHidden)")
        }).disposed(by: disposeBag)
        
        
        
        // totalAllergy에서 추가하기
        addMyAllergyButton.rx.tap.bind(onNext: {

            self.changeUIView(status: true)
            
            guard let totalAllergyVC = self.storyboard?.instantiateViewController(withIdentifier: "TotalAllergyViewController") as? TotalAllergyViewController else { return }

            totalAllergyVC.totalAllergyViewModel = self.totalAllergyViewModel
            
            totalAllergyVC.view.clipsToBounds = false
            totalAllergyVC.view.layer.cornerRadius = 20
            
            let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: totalAllergyVC)
            bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = self.view.bounds.size.height * 0.7
            
            self.present(bottomSheet, animated: true)
            
        }).disposed(by: disposeBag)
        
        
        
        
        // 삭제하기 버튼 클릭
        deleteMyAllergyButton.rx.tap.bind(onNext: {
//            self.totalAllergyViewModel.tapdelete.onNext(self.totalAllergyViewModel.checkMyAllergy.value)
            
            let checkDeletePopup = CheckDeletePopupViewController(nibName: "CheckDeletePopup", bundle: nil)
            
            checkDeletePopup.modalPresentationStyle = .overCurrentContext
            checkDeletePopup.modalTransitionStyle = .crossDissolve // 뷰가 투명해지면서 넘어가는 애니메이션
            checkDeletePopup.totalAllergyViewModel = self.totalAllergyViewModel
            checkDeletePopup.allergyViewStatus = .myAllergy
            
            self.present(checkDeletePopup, animated: false, completion: nil)
            
            print("삭제")
        }).disposed(by: disposeBag)
        
        
        
        
        // 직접 추가하기 버튼 클릭
        directAddMyAllergyButton.rx.tap.bind(onNext: {
            
            self.changeUIView(status: true)
            
            guard let directAddMyAllergyViewController = self.storyboard?.instantiateViewController(withIdentifier: "DirectAddMyAllergyViewController") as? DirectAddMyAllergyViewController else { return }

            directAddMyAllergyViewController.totalAllergyViewModel = self.totalAllergyViewModel
            
            directAddMyAllergyViewController.view.clipsToBounds = false
            directAddMyAllergyViewController.view.layer.cornerRadius = 20
            
            let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: directAddMyAllergyViewController)

            bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = directAddMyAllergyViewController.contentViewheight ?? 1
            print(directAddMyAllergyViewController.contentViewheight)
            
            self.present(bottomSheet, animated: true)
            
        }).disposed(by: disposeBag)
        
        
        
        allCheckButton.rx.tap.bind(onNext: {
            
            if self.totalAllergyViewModel.myAllergyAllCheckStatus == .check {
                print("체크인가")
                self.totalAllergyViewModel.myAllergyAllCheckStatusSubject.onNext(.nonCheck)
                self.allCheckButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                


            } else {
                print("체크아닌가")
                self.totalAllergyViewModel.myAllergyAllCheckStatusSubject.onNext(.check)
                self.allCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
        
        
        dismissButton.rx.tap.bind(onNext: {
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        
        
        
        
        
        addButton.rx.tap.bind(onNext: {
            
            if self.totalAllergyViewModel.addButtonStatus == .nonTap {
                self.changeUIView(status: false)
                
            } else {
                self.changeUIView(status: true)
            }
        }).disposed(by: disposeBag)
        
        
        
        tapGesture.rx.event.bind(onNext: { _ in
            self.changeUIView(status: true)
        }).disposed(by: disposeBag)
    }
}


// MARK: configure View
extension MyAllergyViewController {
    
    func congigureAddButton() {
        addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
        addButton.clipsToBounds = true
        
        addButton.layer.shadowColor = UIColor.black.cgColor // 색깔
        addButton.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        addButton.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        addButton.layer.shadowRadius = 5 // 반경
        addButton.layer.shadowOpacity = 0.3 // alpha값
    }
    
    
    func changeUIView(status: Bool) {
        let imageTitle = status ? "fi-rr-plus-1" : "fi-rr-cross-1"
        self.totalAllergyViewModel.addButtonStatus = status ? .nonTap : .tap
        
        UIView.animate(withDuration: 0.2, animations: {
            self.addButton.setImage(UIImage(named: imageTitle), for: .normal)
            self.addButton.setTitleColor(UIColor.white, for: .normal)
            self.opacityView.isHidden = status
            self.addMyAllergyButton.isHidden = status
            self.directAddMyAllergyButton.isHidden = status
        })
    }
    
}
