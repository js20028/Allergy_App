//
//  TotalAllergyViewController.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/01.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MaterialComponents.MaterialBottomSheet

class TotalAllergyViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var totalAllergyTableView: UITableView!
    @IBOutlet weak var registerMyAllergyButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var deleteAllergyButton: UIButton!
    
    @IBOutlet weak var allCheckButton: UIButton!
    @IBOutlet weak var myAllergyCheckButton: UIButton!
    
    var totalAllergyViewModel: TotalAllergyViewModel?
    
    let disposeBag = DisposeBag()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tableViewNibName = UINib(nibName: "ShowAllergyTableViewCell", bundle: nil)
        
        totalAllergyTableView.register(tableViewNibName, forCellReuseIdentifier: "ShowAllergyTableViewCell")

        self.configureButton()
        
        // tableview bind
        totalAllergyViewModel?.checkAllergy.bind(to: totalAllergyTableView.rx.items(cellIdentifier: "ShowAllergyTableViewCell", cellType: ShowAllergyTableViewCell.self )) { (index, model, cell) in
            
            cell.allergyTitleLabel.text = model.allergyName
            cell.checkAllergyImageView.isHidden = !model.myAllergy
        }
        .disposed(by: disposeBag)
        
        
        // cell 클릭
        totalAllergyTableView.rx.itemSelected.bind(onNext: { indexPath in
            
            self.totalAllergyTableView.deselectRow(at: indexPath, animated: false)
            
            let cell = self.totalAllergyTableView.cellForRow(at: indexPath) as! ShowAllergyTableViewCell
            cell.selectionStyle = .none // 회색으로 바뀌는 cell 선택 스타일 none으로 변경
            cell.checkAllergyImageView.isHidden = !cell.checkAllergyImageView.isHidden // 선택시 체크 이미지 isHiddden속성 변경
            

            self.totalAllergyViewModel?.tapAllergyCell.onNext((indexPath.row, !cell.checkAllergyImageView.isHidden))
            
            print("totalAllergy에서 클릭된 cell의 index: \(indexPath.row), \(!cell.checkAllergyImageView.isHidden)")
            
        }).disposed(by: disposeBag)
        
        
        
        // tap register button
        registerMyAllergyButton.rx.tap.bind(onNext: {
            self.totalAllergyViewModel?.tapRegister.onNext(self.totalAllergyViewModel?.checkAllergy.value ?? [])
            self.dismiss(animated: true)
            
        }).disposed(by: disposeBag)
        
        
        
        
        deleteAllergyButton.rx.tap.bind(onNext: {
//            self.totalAllergyViewModel?.tapTotaldelete.onNext(self.totalAllergyViewModel?.checkAllergy.value ?? [])
            let checkDeletePopup = CheckDeletePopupViewController(nibName: "CheckDeletePopup", bundle: nil)
            
            checkDeletePopup.modalPresentationStyle = .overCurrentContext
            checkDeletePopup.modalTransitionStyle = .crossDissolve // 뷰가 투명해지면서 넘어가는 애니메이션
            checkDeletePopup.totalAllergyViewModel = self.totalAllergyViewModel
            checkDeletePopup.allergyViewStatus = .totalAllergy
            
            self.present(checkDeletePopup, animated: false, completion: nil)
        }).disposed(by: disposeBag)
        
        
        
        
        // 뒤로가기
        dismissButton.rx.tap.bind(onNext: {
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)

        
        
        // 전체체크 버튼
        allCheckButton.rx.tap.bind(onNext: {
            print("전체 알러지 전체 체크 버튼 클릭")
            if self.totalAllergyViewModel?.totalAllergyAllCheckStatus == .check {
                print("체크")
                self.totalAllergyViewModel?.totalAllergyAllCheckStatusSubject.onNext(.check)
                self.allCheckButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                
            } else {
                print("체크x")
                self.totalAllergyViewModel?.totalAllergyAllCheckStatusSubject.onNext(.nonCheck)
                self.allCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
        
        
        // 내 알러지 체크 버튼
        myAllergyCheckButton.rx.tap.bind(onNext: {
            print("전체 알러지 내 알러지 체크 버튼 클릭")
            if self.totalAllergyViewModel?.myAllergyMyCheckStatus == .check {
                self.totalAllergyViewModel?.myAllergyMyCheckStatusSubject.onNext(.check)
                self.myAllergyCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                
            } else {
                self.totalAllergyViewModel?.myAllergyMyCheckStatusSubject.onNext(.nonCheck)
                self.myAllergyCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
            
        }).disposed(by: disposeBag)
    }
    
}


extension TotalAllergyViewController {
    
    func configureButton() {
        self.registerMyAllergyButton.layer.cornerRadius = 10
    }
}
