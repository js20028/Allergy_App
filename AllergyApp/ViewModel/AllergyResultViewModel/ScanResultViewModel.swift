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
    
    let allergyResultModel: AllergyResultModel
    
    var disposeBag = DisposeBag()
    
//    let saveAllergyResult: Observable<AllergyResult>
    
    let allergyResult: PublishSubject<AllergyResult>
    
    let productNameText: BehaviorSubject<String>
    let productIngredientText: BehaviorSubject<String>
    let allergyResultText: BehaviorSubject<String>
    
    let saveButtonTapped: PublishSubject<Void>
    
    init() {
        allergyResultModel = AllergyResultModel()
        allergyResult = PublishSubject()
        
        productNameText = BehaviorSubject(value: "가나다")
        productIngredientText = BehaviorSubject(value: "12345")
        allergyResultText = BehaviorSubject(value: "ㅁㄴㅇㄹ")
        
        saveButtonTapped = PublishSubject()
        
        // 저장 버튼 누르면 아래 함수 실행
        saveButtonTapped.bind(onNext: {
            self.addAllergyResult()
        })
        .disposed(by: disposeBag)
        
        // 결과값 들어오면 coredata 저장
        allergyResult.bind(onNext: {
            self.allergyResultModel.saveAllergyResult(allergyResult: $0)
        })
        .disposed(by: disposeBag)
        
    }
    
    // AllergyResult 만들어서보냄
    func addAllergyResult() {
        Observable.zip(productNameText, productIngredientText,allergyResultText)
            .map { AllergyResult(date: Date(), productName: $0, productIngredient: $1, compareResult: $2) }
            .bind(to: allergyResult)
            .disposed(by: disposeBag)
    }
    
    
}

