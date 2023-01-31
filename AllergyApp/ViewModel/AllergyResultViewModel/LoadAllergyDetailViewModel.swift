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
    let productNameText: PublishSubject<String>
    let productIngredientText: PublishSubject<String>
    let allergyResultText: PublishSubject<String>
    
    init(_ selectedAllergy: AllergyResult) {
        allergyDetail = PublishSubject()
        productNameText = PublishSubject()
        productIngredientText = PublishSubject()
        allergyResultText = PublishSubject()
        
    }
    
}
