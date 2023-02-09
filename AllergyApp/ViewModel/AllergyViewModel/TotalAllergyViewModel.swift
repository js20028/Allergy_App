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
    
    var testAllergy = [Allergy]()
    
    var allergyModel: AllergyModel
    
    lazy var totalAllergy = BehaviorRelay<[Allergy]>(value: []) // totalAllergy
    lazy var myAllergy = BehaviorRelay<[Allergy]>(value: []) // myAllergy
    
    var tapAllergyCell = PublishSubject<(Int, Bool)>() // cell을 텝할때마다 checkAllergy에 값을 넣어주기 위한 subject
    var checkAllergy = BehaviorRelay<[Allergy]>(value: []) // totalAllergy 선택된 cell 관리
    
    var tapMyAllergyCell = PublishSubject<(Int, Bool)>() // cell을 텝할때마다 checkMyAllergy에 값을 넣어주기 위한 subject
    var checkMyAllergy = BehaviorRelay<[Allergy]>(value: []) // myAllergy 선택된 cell 관리
    
    var tapRegister = PublishSubject<[Allergy]>() // register button 관리
    
    var tapdelete = PublishSubject<[Allergy]>() // delete button 관리
    
    var directAddAllergy = PublishSubject<Allergy>()
    
    let disposeBag = DisposeBag()
    
    init(allergyModel: AllergyModel) {
        print("init 실행")
        self.allergyModel = allergyModel

        testAllergy = self.allergyModel.testAllergy

        // viewModel에 있는 totalAllergy값을 넣어줌
        totalAllergy.accept(testAllergy)

        // checkAllergy에는 totalAllergy 값을 먼저 넣어줌
        checkAllergy.accept(totalAllergy.value)
        
        // checkAllergy에는 myAllergy 값을 먼저 넣어줌
        checkMyAllergy.accept(myAllergy.value)
        
        
        
        
        
        // 등록하기 버튼을 누를때 실행 (allergyModel에 totalAllergy로 보냄)
        totalAllergy.bind(onNext: { allergy in
            // totalAllergyd에 값이 들어오면 true인것만 myAllergy에 값 전달
            self.myAllergy.accept(allergy.filter{ $0.myAllergy == true })
            self.checkAllergy.accept(allergy)
            self.testAllergy = allergy
            print(allergy,"값이 뭘까?")
            
            self.allergyModel.testAllergy = allergy
            self.allergyModel.totalAllergy.accept(allergy)
        }).disposed(by: disposeBag)
        
        
        
        
        myAllergy.bind(onNext: { myallergy in
            self.checkMyAllergy.accept(myallergy)
        }).disposed(by: disposeBag)
        
        
        
        
        // 등록하기 버튼누를때 실행
        tapRegister.bind(onNext: { register in
            print("tabRegister subscribe실행됨, \(register)")
            self.totalAllergy.accept(register)
            self.testAllergy = register
        }).disposed(by: disposeBag)
        
        
        
        
        // checkMyallergy랑 totalAllergy를 비교해서 myAllergy에 값전달 해야함
        tapdelete.bind(onNext: { checkMyAllergy in

            var totalAllergy = self.totalAllergy.value
            
            totalAllergy = totalAllergy.map { total in
                let check = checkMyAllergy.first(where: { $0.allergyName == total.allergyName })
                return check.map { Allergy(allergyName: total.allergyName, myAllergy: $0.myAllergy) } ?? total
            }
            
            self.totalAllergy.accept(totalAllergy)
            self.testAllergy = totalAllergy
        }).disposed(by: disposeBag)
        
        
        
        
        // cell 클릭할떄 마다 실행 (cell을 텝 할때마다 checkAllergy에 값을 보내줌)
        tapMyAllergyCell.subscribe(onNext: { [weak self] index, check in
            
            guard let self = self else { return }
            var allergen = self.checkMyAllergy.value
            allergen[index].myAllergy = check
            
            self.checkMyAllergy.accept(allergen)
            print(self.checkMyAllergy.value,"체크 알러지?")
        }).disposed(by: disposeBag)
        
        
        
        // cell 클릭할떄 마다 실행 (cell을 텝 할때마다 checkAllergy에 값을 보내줌)
        tapAllergyCell.bind(onNext: { index, check in
            var allergen = self.checkAllergy.value
            allergen[index].myAllergy = check
            self.checkAllergy.accept(allergen)
        }).disposed(by: disposeBag)
        
        
        
        
        // 직접 버튼 누를때 실행
        directAddAllergy.bind(onNext: { allergy in
            self.testAllergy.append(allergy)
            self.totalAllergy.accept(self.testAllergy)
        }).disposed(by: disposeBag)
    }

}
