//
//  LoadAllergyViewModel.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/01/26.
//

import Foundation
import RxSwift
import RxCocoa

class LoadAllergyViewModel {

    var disposeBag = DisposeBag()
    
    let loadAllergyList: BehaviorSubject<[AllergyResult]>
    let loadList = [
        AllergyResult(productName: "소고기", productIngredient: "단백질, 지방", allergyResult: "단백질"),
        AllergyResult(productName: "사과", productIngredient: "탄수화물, 비타민", allergyResult: "없음"),
        AllergyResult(productName: "치즈", productIngredient: "우유, 지방", allergyResult: "우유")
    ]
    
    init() {
        
        loadAllergyList = BehaviorSubject(value: [])
        loadAllergyList.onNext(loadList)
        
    }
}
