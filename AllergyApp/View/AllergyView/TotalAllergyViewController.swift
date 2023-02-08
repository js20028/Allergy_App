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
    
    var totalAllergyViewModel: TotalAllergyViewModel?
    
    let disposeBag = DisposeBag()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tableViewNibName = UINib(nibName: "ShowAllergyTableViewCell", bundle: nil)
        
        totalAllergyTableView.register(tableViewNibName, forCellReuseIdentifier: "ShowAllergyTableViewCell")

        
        // tableview bind
        totalAllergyViewModel?.totalAllergy.bind(to: totalAllergyTableView.rx.items(cellIdentifier: "ShowAllergyTableViewCell", cellType: ShowAllergyTableViewCell.self )) { (index, model, cell) in
            
            cell.allergyTitleLabel.text = model.allergyName
            cell.checkAllergyImageView.isHidden = !model.myAllergy
        }
        .disposed(by: disposeBag)
        
        
        // cell 클릭
        totalAllergyTableView.rx.itemSelected.bind(onNext: { indexPath in
            
            self.totalAllergyTableView.deselectRow(at: indexPath, animated: false)
            
            let cell = self.totalAllergyTableView.cellForRow(at: indexPath) as! ShowAllergyTableViewCell
            cell.selectionStyle = .none // 회색으로 바뀌는 cell 선택 스타일 none으로 변경
            cell.checkImageView.isHidden = !cell.checkImageView.isHidden // 선택시 체크 이미지 isHiddden속성 변경
            

            self.totalAllergyViewModel?.tapAllergyCell.onNext((indexPath.row, !cell.checkImageView.isHidden))
            
            print("totalAllergy에서 클릭된 cell의 index: \(indexPath.row), \(!cell.checkImageView.isHidden)")
            
        }).disposed(by: disposeBag)
        
        
        
        // tap register button
        registerMyAllergyButton.rx.tap.bind(onNext: {
            self.totalAllergyViewModel?.tapRegister.onNext(self.totalAllergyViewModel?.checkAllergy.value ?? [])
            self.dismiss(animated: true)
            
        }).disposed(by: disposeBag)
        
        
        // 뒤로가기
        dismissButton.rx.tap.bind(onNext: {
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)

    }
    
}

