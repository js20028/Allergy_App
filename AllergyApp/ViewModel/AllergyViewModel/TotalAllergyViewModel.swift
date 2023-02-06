//
//  TotalAllergyViewModel.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/01.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TotalAllergyViewModel {
    
    let allergyModel: AllergyModel
    
    let totalAllergy = BehaviorRelay<[Allergy]>(value: []) // totalAllergy
    
    let tapAllergyCell = PublishSubject<(Int, Bool)>() // cell을 텝할때마다 checkAllergy에 값을 넣어주기 위한 subject
    let checkAllergy = BehaviorRelay<[Allergy]>(value: []) // 선택된 cell 관리
    
    let disposeBag = DisposeBag()
    
    init(allergyModel: AllergyModel) {
        print("init 실행")
        self.allergyModel = allergyModel
        
        // viewModel에 있는 totalAllergy값을 넣어줌
        totalAllergy.accept(allergyModel.totalAllergy.value)
    
        
        
        // checkAllergy에는 myAllergy 값을 먼저 넣어줌
        checkAllergy.accept(totalAllergy.value)
        
        
        
        // cell 클릭할떄 마다 실행
        tapAllergyCell.subscribe(onNext: { [weak self] index, check in
            guard let self = self else { return }
            var allergen = self.checkAllergy.value
            allergen[index].myAllergy = check
            self.checkAllergy.accept(allergen)
        }).disposed(by: disposeBag)
        
        
        
        // 등록하기 버튼을 누를때 실행
        totalAllergy.subscribe(onNext: { [weak self] allergy in
            guard let self = self else { return }
            self.allergyModel.totalAllergy.accept(self.totalAllergy.value)
            print(allergy,"알러지이!")

        }).disposed(by: disposeBag)
        
    }
    
}
