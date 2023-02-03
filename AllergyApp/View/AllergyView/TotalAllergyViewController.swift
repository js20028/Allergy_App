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

class TotalAllergyViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var totalAllergyTableView: UITableView!
    
    private let totalAllergyViewModel: TotalAllergyViewModel
    
    let disposeBag = DisposeBag()
    
    init(totalAllergyViewModel: TotalAllergyViewModel) {
        self.totalAllergyViewModel = totalAllergyViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.totalAllergyViewModel = TotalAllergyViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableview delegate
        totalAllergyTableView.rx.setDelegate(self)
                    .disposed(by: disposeBag)
        
        
        totalAllergyViewModel.observerAllergy.bind(to: totalAllergyTableView.rx.items(cellIdentifier: "ShowAllergyTableViewCell", cellType: ShowAllergyTableViewCell.self )) { (index, model, cell) in
            
            cell.allergyTitleLabel.text = model.allergyName
            cell.checkAllergyImageView.isHidden = model.myAllergy

        }
        .disposed(by: disposeBag)
        
        
        
        // 4. Cell selection을 처리하는 delegate 정의
        totalAllergyTableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                
                self.totalAllergyTableView.deselectRow(at: indexPath, animated: false) // cell선택 해제
                let cell = self.totalAllergyTableView.cellForRow(at: indexPath) as! ShowAllergyTableViewCell
                cell.selectionStyle = .none // 회색으로 바뀌는 cell 선택 스타일 none으로 변경
                cell.checkAllergyImageView.isHidden = !cell.checkAllergyImageView.isHidden // 선택시 체크 이미지 isHiddden속성 변경

            })
            .disposed(by: disposeBag)
        

        
    }
    
    private func registerXib() {
        let tableViewNibName = UINib(nibName: "ShowAllergyTableViewCell", bundle: nil)
        self.totalAllergyTableView.register(tableViewNibName, forCellReuseIdentifier: "ShowAllergyTableViewCell")
    }
    
}
