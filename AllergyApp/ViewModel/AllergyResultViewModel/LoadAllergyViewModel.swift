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
        AllergyResult(date: Date(),productName: "치즈", productIngredient: "우유, 지방", allergyResult: "우유"),
        AllergyResult(date: Date(), productName: "제크", productIngredient: "밀가루(밀:미국산),가공유지(팜분별유(부분경화유:말레이시아산)),쇼트닝Ⅰ(정제가공유지(부분경화유:말레이시아산),정제우지(호주산)),백설탕,산도조절제,액상과당,천일염,쇼트닝Ⅱ,맥아분말,치즈분말,레시틴,유청단백분말,효소제,합성착향료(브래드향)", allergyResult: "밀,우유,대두,쇠고기 함유")
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
