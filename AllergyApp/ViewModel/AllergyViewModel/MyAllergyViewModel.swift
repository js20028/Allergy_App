//
//  myAllergyViewModel.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/01/31.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class MyAllergyViewModel {
    
    let allergyModel: AllergyModel
    let totalAllergy = BehaviorRelay<[Allergy]>(value: []) // myAllergy
    let myAllergy = BehaviorRelay<[Allergy]>(value: []) // myAllergy
    let disposeBag = DisposeBag()
    
    init(allergyModel: AllergyModel) {
        self.allergyModel = allergyModel
        
        myAllergy.accept(self.allergyModel.totalAllergy.value)
        
        self.allergyModel.myAllergy.debug().bind(onNext: { myAllergies in
            print(myAllergies,"제에발")
            self.myAllergy.accept(myAllergies)
        }).disposed(by: disposeBag)
        
        
        
        
        myAllergy.bind(onNext: { myallergie in
            print(myallergie,"이건 뭘까")
        })

    }
}
