//
//  TotalAllergyViewModel.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/01.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TotalAllergyViewModel {
    
    var allergyList: [Allergy] = [
        Allergy(myAllergy: "myallergy1", allergyName: "allergy1"),
        Allergy(myAllergy: "myallergy2", allergyName: "allergy2"),
        Allergy(myAllergy: "myallergy3", allergyName: "allergy3")
    ]
    
    var observerAllergy = BehaviorSubject<[Allergy]>(value: [])
    
    init() {
        observerAllergy.onNext(allergyList)
    }
    
}
