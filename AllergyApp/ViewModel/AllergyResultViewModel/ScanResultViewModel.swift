//
//  ScanResultViewModel.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/02/01.
//

import Foundation
import RxSwift
import RxCocoa

class ScanResultViewModel {
    
    var disposeBag = DisposeBag()
    
    let productNameText: BehaviorSubject<String>
    let productIngredientText: BehaviorSubject<String>
    let allergyResultText: BehaviorSubject<String>
    
    let saveButtonTapped: PublishSubject<Void>
    
    init() {
        productNameText = BehaviorSubject(value: "")
        productIngredientText = BehaviorSubject(value: "")
        allergyResultText = BehaviorSubject(value: "")
        
        saveButtonTapped = PublishSubject()
    }
    
    
}

