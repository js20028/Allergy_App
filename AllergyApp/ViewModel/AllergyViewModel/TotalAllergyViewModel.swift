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

enum allCheckStatus {
    case check
    case nonCheck
}

enum addButtonStatus {
    case tap
    case nonTap
}

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
    var tapTotaldelete = PublishSubject<[Allergy]>() // totalAllergy에서 delete button 관리
    var tapdelete = PublishSubject<[Allergy]>() // delete button 관리
    
    var tapAddButton = PublishSubject<[addButtonStatus]>() // add Button 관리
    
    var directAddAllergy = PublishSubject<Allergy>() // allergy 직접 추가
    
    // myAllergy에 전체 체크 속성
    var myAllergyAllCheckStatusSubject = PublishSubject<allCheckStatus>()
    var myAllergyAllCheckStatus: allCheckStatus = .check
    
    // totalAllergy에 전체 체크 속성
    var totalAllergyAllCheckStatusSubject = PublishSubject<allCheckStatus>()
    var totalAllergyAllCheckStatus: allCheckStatus = .check
    
    // totalAllergy에 내 알러지 체크 속성
    var myAllergyMyCheckStatusSubject = PublishSubject<allCheckStatus>()
    var myAllergyMyCheckStatus: allCheckStatus = .nonCheck
    
    // button클릭 상태
    var addButtonStatusSubject = PublishSubject<addButtonStatus>()
    var addButtonStatus: addButtonStatus = .nonTap
    
    // ui 상태
    var uiStatus = BehaviorSubject<Bool>(value: true)
    
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
            self.testAllergy = allergy
            // totalAllergyd에 값이 들어오면 true인것만 myAllergy에 값 전달
            self.myAllergy.accept(allergy.filter{ $0.myAllergy == true })
            self.checkAllergy.accept(allergy)
            
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
        
        
        
        // totalAllergy에서 값 삭제
        tapTotaldelete.bind(onNext: { checkTotalAllergy in
            
            let deleteAllergy = checkTotalAllergy.filter { $0.myAllergy == false }
            
            self.totalAllergy.accept(deleteAllergy)
            
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
        
        
        
        
        // 마이 알러지 페이지에서 전체 체크 버튼 클릭시 체크 알러지 변경
        myAllergyAllCheckStatusSubject.bind(onNext: { _ in
            print("혹시?")
            let check = self.checkMyAllergy.value
            
            switch self.myAllergyAllCheckStatus {
            case .check :
                print("이거")
                let checkMy = check.map{ my in
                    var myAllergy = my
                    myAllergy.myAllergy = false
                    return myAllergy
                }
                
                self.checkMyAllergy.accept(checkMy)
                self.myAllergyAllCheckStatus = .nonCheck
                
            case .nonCheck :
                print("거이")
                let checkMy = check.map{ my in
                    var myAllergy = my
                    myAllergy.myAllergy = true
                    return myAllergy
                }
                
                self.checkMyAllergy.accept(checkMy)
                
                self.myAllergyAllCheckStatus = .check
                
            }
        }).disposed(by: disposeBag)
        
        
        
        
        // 전체 알러지 페이지에서 전체 체크 버튼 클릭시 체크 알러지 변경
        totalAllergyAllCheckStatusSubject.bind(onNext: { _ in
            
            let check = self.checkAllergy.value
            
            switch self.totalAllergyAllCheckStatus {
            case .check :
                
                let checkMy = check.map{ my in
                    var myAllergy = my
                    myAllergy.myAllergy = true
                    return myAllergy
                }
                
                self.checkAllergy.accept(checkMy)
                self.totalAllergyAllCheckStatus = .nonCheck
                
            case .nonCheck :
                
                let checkMy = check.map{ my in
                    var myAllergy = my
                    myAllergy.myAllergy = false
                    return myAllergy
                }
                
                self.checkAllergy.accept(checkMy)
                
                self.totalAllergyAllCheckStatus = .check
                
            }
        }).disposed(by: disposeBag)
        
        
        
        
        // 전체 알러지 페이지에서 내 알러지 체크 버튼 클릭시 체크 알러지 변경
        myAllergyMyCheckStatusSubject.bind(onNext: { _ in
            self.checkAllergy.accept(self.testAllergy)
        }).disposed(by: disposeBag)
        
        
        
        
        // add 버튼 클릭시 상태 변경
        tapAddButton.bind(onNext: { _ in
            
            switch self.addButtonStatus {
            case .nonTap:
                self.addButtonStatus = .tap
                self.addButtonStatusSubject.onNext(.tap)
                self.uiStatus.onNext(false)
                
            case .tap:
                self.addButtonStatus = .nonTap
                self.addButtonStatusSubject.onNext(.nonTap)
                self.uiStatus.onNext(true)
            }
            
        }).disposed(by: disposeBag)
        
        
    }

}
