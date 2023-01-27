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
    
    let loadAllergyList: BehaviorSubject<[String]>
    let loadList = ["알러지1", "알러지2", "알러지3", "알러지4", "알러지5", "알러지6"]
    
    init() {
        
        loadAllergyList = BehaviorSubject(value: [])
        loadAllergyList.onNext(loadList)
        
    }
}
