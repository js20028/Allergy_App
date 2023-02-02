//
//  AllergyModel.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/02.
//

import Foundation
import RxSwift

class AllergyModel {
    
    // 각각 totalAllergy, myAllergy값을 저장하는 객체
    var totalAllergy: [Allergy] = []
    var myAllergy: [Allergy] = []
    
    // 각각 totalAllergy, myAllergy값을 관찰하는 객체
    private let totalAllergySubject = BehaviorSubject<[Allergy]>(value: [])
    private let myAllergySubject = BehaviorSubject<[Allergy]>(value: [])
    
    
    // init에서 자동으로 coredata에 저장된 allergy값 불러오기
    init() {
        self.fetchAlergy()
    }
    
    // totalAllergy, myallergy를 update해주는 메서드
    func updateTotalAllergy(allergies: [Allergy]) {
        totalAllergy = allergies
        totalAllergySubject.onNext(allergies)
        
        myAllergy = allergies.filter({$0.myAllergy == true})
        myAllergySubject.onNext(myAllergy)
    }
    
    // core data에서 저장된 allergy를 불러오는 메서드
    func fetchAlergy() {
        print("coredata fetch Allergy")
    }
    
    // core data에 allergy 저장하는 메서드
    func loadAllergy() {
        print("coredata load Allergy")
    }

}
