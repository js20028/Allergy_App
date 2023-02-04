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
    
    let deleteIndex: PublishSubject<IndexPath>
    
    let loadAllergyList: BehaviorSubject<[AllergyResult]>
    var loadList = [
        AllergyResult(date: Date(), productName: "소고기", productIngredient: "단백질, 지방", allergyResult: "단백질"),
        AllergyResult(date: Date(),productName: "사과", productIngredient: "탄수화물, 비타민", allergyResult: "없음"),
        AllergyResult(date: Date(),productName: "치즈", productIngredient: "우유, 지방", allergyResult: "우유")
    ]
    
    init() {
        loadAllergyList = BehaviorSubject(value: [])
        
        deleteIndex = PublishSubject()
        
        deleteIndex.subscribe(onNext: { [weak self] in
            self?.deleteAllergyResult(indexPath: $0)
        })
        .disposed(by: disposeBag)
        
        loadAllergyList.onNext(loadList)
        
    }
    
    func addAllergyResult(allergyResult: AllergyResult) {
        loadList.append(allergyResult)
        loadAllergyList.onNext(loadList)
    }
    
    func deleteAllergyResult(indexPath: IndexPath) {
        loadList.remove(at: indexPath.row)
        loadAllergyList.onNext(loadList)
    }
}
