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
        Allergy(allergyName: "allergy1", myAllergy: true),
        Allergy(allergyName: "allergy2", myAllergy: false),
        Allergy(allergyName: "allergy3", myAllergy: true)
    ]
    
    var observerAllergy = BehaviorSubject<[Allergy]>(value: [])
    
    init() {
        observerAllergy.onNext(allergyList)
    }
    
}
