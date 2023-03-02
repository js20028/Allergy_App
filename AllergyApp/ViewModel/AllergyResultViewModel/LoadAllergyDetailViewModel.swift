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
    
//    let popupTitleText = BehaviorSubject<String>(value: "정말로 삭제하시겠습니까?")
//    let popupContentText = BehaviorSubject<String>(value: "저장된 알러지 결과가 삭제됩니다.")
//    let popupConfirmButtonText = BehaviorSubject<String>(value: "삭제")
    
    init(_ selectedAllergy: AllergyResult) {
        
        allergyDetail = PublishSubject()
        
        createDateText = BehaviorSubject(value: selectedAllergy.dateToString())
        productNameText = BehaviorSubject(value: selectedAllergy.productName)
        productIngredientText = BehaviorSubject(value: selectedAllergy.productIngredient)
        productAllergyText = BehaviorSubject(value: selectedAllergy.productAllergy)
        allergyResultText = BehaviorSubject(value: selectedAllergy.compareResult)
        
        deleteButtonTapped = PublishSubject()
    
    }
    
}
