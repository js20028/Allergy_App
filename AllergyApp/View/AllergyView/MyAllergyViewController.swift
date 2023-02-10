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
        myAllergyTableView.register(tableViewNibName, forCellReuseIdentifier: "ShowAllergyTableViewCell")
        
        // tableview bind
        totalAllergyViewModel.myAllergy.bind(to: myAllergyTableView.rx.items(cellIdentifier: "ShowAllergyTableViewCell", cellType: ShowAllergyTableViewCell.self )) { (index, model, cell) in
            
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
        
        
        
        
        addMyAllergyButton.rx.tap.bind(onNext: {

            guard let totalAllergyVC = self.storyboard?.instantiateViewController(withIdentifier: "TotalAllergyViewController") as? TotalAllergyViewController else { return }

            totalAllergyVC.totalAllergyViewModel = self.totalAllergyViewModel
            
            totalAllergyVC.view.clipsToBounds = false
            totalAllergyVC.view.layer.cornerRadius = 20
            
            let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: totalAllergyVC)
            bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = self.view.bounds.size.height * 0.5
            
            self.present(bottomSheet, animated: true)
            
        }).disposed(by: disposeBag)
        
        
        
        
        // 삭제하기 버튼 클릭
        deleteMyAllergyButton.rx.tap.bind(onNext: {
            self.totalAllergyViewModel.tapdelete.onNext(self.totalAllergyViewModel.checkMyAllergy.value)
            print("삭제")
        }).disposed(by: disposeBag)
        
        
        
        
        // 직접 추가하기 버튼 클릭
        directAddMyAllergyButton.rx.tap.bind(onNext: {
            
            guard let directAddMyAllergyViewController = self.storyboard?.instantiateViewController(withIdentifier: "DirectAddMyAllergyViewController") as? DirectAddMyAllergyViewController else { return }

            directAddMyAllergyViewController.totalAllergyViewModel = self.totalAllergyViewModel
            
            directAddMyAllergyViewController.view.clipsToBounds = false
            directAddMyAllergyViewController.view.layer.cornerRadius = 20
            
            let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: directAddMyAllergyViewController)
//            bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = self.view.bounds.size.height * 0.2
            bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = directAddMyAllergyViewController.contentViewheight ?? 1
            print(directAddMyAllergyViewController.contentViewheight)
            self.present(bottomSheet, animated: true)
            
        }).disposed(by: disposeBag)
    }
}
