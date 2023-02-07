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
    
    var testAllergy: [Allergy] = [
        Allergy(allergyName: "allergy1", myAllergy: true),
        Allergy(allergyName: "allergy2", myAllergy: true),
        Allergy(allergyName: "allergy3", myAllergy: false),
        Allergy(allergyName: "allergy4", myAllergy: true),
        Allergy(allergyName: "allergy5", myAllergy: false),
        Allergy(allergyName: "allergy6", myAllergy: true),
        Allergy(allergyName: "allergy7", myAllergy: true),
        Allergy(allergyName: "allergy8", myAllergy: false),
        Allergy(allergyName: "allergy9", myAllergy: true),
        Allergy(allergyName: "allergy10", myAllergy: false)
    ]

    // value에는 coredata에서 받아온 값을 넣어줌 (일단은 임시로 testAllergy를 넣음)
    lazy var totalAllergy = BehaviorRelay<[Allergy]>(value: testAllergy)
    
    let disposeBag = DisposeBag()
    
    init() {
        // 첨에 allergyModel이 init될때 coredata 불러오기
        
        totalAllergy.bind(onNext: { allergies in
            // 여기에 totalAllergy값을 coredata에 저장
            
//            self.testAllergy = allergies
            self.testAllergy = allergies
            print(self.testAllergy,"전체 알러지는?")
            
            self.testAllergy = allergies
        }).disposed(by: disposeBag)
        
        
    }

}

