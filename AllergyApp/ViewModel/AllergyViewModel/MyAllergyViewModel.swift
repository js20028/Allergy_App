////
////  myAllergyViewModel.swift
////  AllergyApp
////
////  Created by 김정태 on 2023/01/31.
////
//
//import Foundation
//import UIKit
//import RxCocoa
//import RxSwift
//
//class MyAllergyViewModel {
//
//    var allergyModel: AllergyModel
//
//    var total: [Allergy] = []
//
//    lazy var totalAllergy = BehaviorRelay<[Allergy]>(value: []) // totalAllergy
//    lazy var myAllergy = BehaviorRelay<[Allergy]>(value: []) // myAllergy
//
//    var tapMyAllergyCell = PublishSubject<(Int, Bool)>() // cell을 텝할때마다 checkAllergy에 값을 넣어주기 위한 subject
//    var checkMyAllergy = BehaviorRelay<[Allergy]>(value: []) // 선택된 cell 관리
//
//    let disposeBag = DisposeBag()
//
//    init(allergyModel: AllergyModel) {
//        print("myallergymodel init")
//        self.allergyModel = allergyModel
//
//        self.total = allergyModel.testAllergy
//        self.totalAllergy.accept(self.allergyModel.totalAllergy.value)
//
//
//        // allergyModel에 있는 totalAllergy 값이 들어오면 이거 실행되게 할라 했는데 안됨
//        allergyModel.totalAllergy.bind(onNext: { total in
//            self.totalAllergy.accept(total)
//            print("이거 됏나>")
//        }).disposed(by: disposeBag)
//
//
//
//        // totalAllergyd에 값이 들어오면 true인것만 myAllergy에 값 전달
//        totalAllergy.bind(onNext: { allergies in
//            self.myAllergy.accept(allergies.filter{ $0.myAllergy == true })
//            print(self.myAllergy.value,"마이 알러지")
//        }).disposed(by: disposeBag)
//
//
//
//
//        // checkAllergy에는 myAllergy 값을 먼저 넣어줌
//        checkMyAllergy.accept(myAllergy.value)
//
//
//
//
//        // checkMyallergy랑 totalAllergy를 비교해서 myAllergy에 값전달 해야함
//        checkMyAllergy.bind(onNext: { myAllergies in
//
//        }).disposed(by: disposeBag)
//
//
//
//        // cell 클릭할떄 마다 실행 (cell을 텝 할때마다 checkAllergy에 값을 보내줌)
//        tapMyAllergyCell.subscribe(onNext: { [weak self] index, check in
//            guard let self = self else { return }
//            var allergen = self.checkMyAllergy.value
//            allergen[index].myAllergy = check
//            self.checkMyAllergy.accept(allergen)
//            print(self.checkMyAllergy.value,"체크 알러지?")
//        }).disposed(by: disposeBag)
//
//
//
//    }
//}
