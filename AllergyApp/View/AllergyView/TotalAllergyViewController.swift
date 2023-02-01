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

class TotalAllergyViewController: UIViewController {
    
    @IBOutlet weak var totalAllergyTableView: UITableView!
    
    private let totalAllergyViewModel: TotalAllergyViewModel
    
    let disposeBag = DisposeBag()
    
    init(totalAllergyViewModel: TotalAllergyViewModel) {
        self.totalAllergyViewModel = totalAllergyViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.totalAllergyViewModel = TotalAllergyViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalAllergyViewModel.observerAllergy.bind(to: totalAllergyTableView.rx.items(cellIdentifier: "ShowAllergyTableViewCell", cellType: ShowAllergyTableViewCell.self )) { (_, model, cell) in
            
//            cell.allergyTitleLabel.text =

        }
        .disposed(by: disposeBag)
        
        // 4. Cell selection을 처리하는 delegate 정의
        totalAllergyTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.totalAllergyTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func registerXib() {
        let tableViewNibName = UINib(nibName: "ShowAllergyTableViewCell", bundle: nil)
        self.totalAllergyTableView.register(tableViewNibName, forCellReuseIdentifier: "ShowAllergyTableViewCell")
    }
    
}
