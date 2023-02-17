//
//  LoadAllergyDetailViewModel.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/01/30.
//

import Foundation
import RxSwift
import RxCocoa

class LoadAllergyDetailViewModel {
    var disposeBag = DisposeBag()
    
    let allergyDetail: PublishSubject<AllergyResult>
    
    let createDateText: BehaviorSubject<String>
    let productNameText: BehaviorSubject<String>
    let productIngredientText: BehaviorSubject<String>
    let productAllergyText: BehaviorSubject<String>
    let allergyResultText: BehaviorSubject<String>
    
    let deleteButtonTapped: PublishSubject<Void>
    
    init(_ selectedAllergy: AllergyResult) {
        
        allergyDetail = PublishSubject()
        
        createDateText = BehaviorSubject(value: selectedAllergy.dateToString())
        productNameText = BehaviorSubject(value: selectedAllergy.productName)
        productIngredientText = BehaviorSubject(value: selectedAllergy.productIngredient)
        productAllergyText = BehaviorSubject(value: selectedAllergy.productAllergy)
        print(selectedAllergy.productAllergy, " 선택한것 프로덕트 알러지!@#!@#")
        allergyResultText = BehaviorSubject(value: selectedAllergy.compareResult)
        
        deleteButtonTapped = PublishSubject()
    
    }
    
}
