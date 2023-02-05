//
//  AllergyModel.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/02.
//

import Foundation
import RxSwift
import RxRelay

class AllergyModel {
    
    let testAllergy: [Allergy] = [
        Allergy(allergyName: "allergy1", myAllergy: true),
        Allergy(allergyName: "allergy2", myAllergy: true),
        Allergy(allergyName: "allergy3", myAllergy: false),
        Allergy(allergyName: "allergy4", myAllergy: true),
        Allergy(allergyName: "allergy5", myAllergy: false)
    ]

    // value에는 coredata에서 받아온 값을 넣어줌 (일단은 임시로 testAllergy를 넣음)
    lazy var totalAllergy = BehaviorRelay<[Allergy]>(value: testAllergy)
    let myAllergy = BehaviorRelay<[Allergy]>(value: [])
    
    let disposeBag = DisposeBag()
    
    init() {
        totalAllergy.bind(onNext: { allergies in
            print(self.totalAllergy.value,"전체 알러지는?")
            self.myAllergy.accept(allergies.filter{ $0.myAllergy == true })
//            print(self.myAllergy.value, "마이 알러지는?")
        }).disposed(by: disposeBag)
        
        myAllergy.bind(onNext: { myAllergies in
            print(myAllergies,"마이 알러지?")
        }).disposed(by: disposeBag)
    }
}
