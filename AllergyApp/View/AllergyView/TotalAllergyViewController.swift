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
    @IBOutlet weak var registerMyAllergyButton: UITableView!
    
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
        
        let tableViewNibName = UINib(nibName: "ShowAllergyTableViewCell", bundle: nil)
        totalAllergyTableView.register(tableViewNibName, forCellReuseIdentifier: "ShowAllergyTableViewCell")
        
        // tableview bind
        totalAllergyViewModel.totalAllergy.bind(to: totalAllergyTableView.rx.items(cellIdentifier: "ShowAllergyTableViewCell", cellType: ShowAllergyTableViewCell.self )) { (index, model, cell) in
            cell.allergyTitleLabel.text = model.allergyName
            cell.checkImageView.isHidden = !model.myAllergy
        }
        .disposed(by: disposeBag)
        
        
        // cell 클릭
        totalAllergyTableView.rx.itemSelected.bind(onNext: { indexPath in
            self.totalAllergyTableView.deselectRow(at: indexPath, animated: false)
            
            let cell = self.totalAllergyTableView.cellForRow(at: indexPath) as! ShowAllergyTableViewCell
            cell.selectionStyle = .none // 회색으로 바뀌는 cell 선택 스타일 none으로 변경
            cell.checkImageView.isHidden = !cell.checkImageView.isHidden // 선택시 체크 이미지 isHiddden속성 변경
            

            self.totalAllergyViewModel.tapAllergyCell.onNext((indexPath.row, !cell.checkImageView.isHidden))
            
            print("클릭된 cell의 index: \(indexPath.row), \(!cell.checkImageView.isHidden)")
        }).disposed(by: disposeBag)
        
        
        
        // tap register button
        registerMyAllergyButton.rx.tap.bind(onNext: {
            self.totalAllergyViewModel.totalAllergy.accept(self.totalAllergyViewModel.checkAllergy.value)
        }).disposed(by: disposeBag)
        
            

    }
}
