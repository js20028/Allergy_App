//
//  AllergyModel.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/02.
//

import Foundation
import RxSwift
import RxRelay
import CoreData

class AllergyModel {
    
    let fisrtOn = PublishRelay<Bool>()
    var testAllergy: [Allergy] = []
            
    // value에는 coredata에서 받아온 값을 넣어줌 (일단은 임시로 testAllergy를 넣음)
    lazy var totalAllergy = PublishRelay<[Allergy]>()
    
    let disposeBag = DisposeBag()
    
    init() {
        // 첨에 allergyModel이 init될때 coredata 불러오기
        
        if UserDefault().loadFirstOnUserDefault() == true {
            print("이거")
            fetchAllergies()
        } else {
            print("이거거")
            UserDefault().setFirestOnUserDeafault(firstOn: true)
            
            testAllergy = [
                Allergy(allergyName: "우유", myAllergy: false),
                Allergy(allergyName: "메밀", myAllergy: false),
                Allergy(allergyName: "땅콩", myAllergy: false),
                Allergy(allergyName: "대두", myAllergy: false),
                Allergy(allergyName: "밀", myAllergy: false),
                Allergy(allergyName: "고등어", myAllergy: false),
                Allergy(allergyName: "게", myAllergy: false),
                Allergy(allergyName: "새우", myAllergy: false),
                Allergy(allergyName: "복숭아", myAllergy: false),
                Allergy(allergyName: "토마토", myAllergy: false),
                Allergy(allergyName: "아황산류", myAllergy: false),
                Allergy(allergyName: "호두", myAllergy: false),
                Allergy(allergyName: "닭고기", myAllergy: false),
                Allergy(allergyName: "쇠고기", myAllergy: false),
                Allergy(allergyName: "돼지고기", myAllergy: false),
                Allergy(allergyName: "오징어", myAllergy: false),
                Allergy(allergyName: "조개류", myAllergy: false),
                Allergy(allergyName: "잣", myAllergy: false),
                Allergy(allergyName: "깨", myAllergy: false),
                Allergy(allergyName: "두유", myAllergy: false)
            ]
            
            self.totalAllergy.accept(testAllergy)
            saveAllergies()
        }
        

        totalAllergy.bind(onNext: { allergies in
            // 여기에 totalAllergy값을 coredata에 저장
            self.testAllergy = allergies
            self.testAllergy.sort { $0.allergyName > $1.allergyName }
            
            self.deleteAlelrgies()
            self.saveAllergies()

        }).disposed(by: disposeBag)
//        asd()

    }
    
    // coredata save
    func saveAllergies() {
        print("coredata 저장")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CoreAllergy", in: context)
                
        for allergy in testAllergy {
            print(allergy,"저장되는거 맞니?")
            if let entity = entity {
                let managedObject = NSManagedObject(entity: entity, insertInto: context)
                managedObject.setValue(allergy.allergyName, forKey: "allergyName")
                managedObject.setValue(allergy.myAllergy, forKey: "myAllergy")
            }
        }
        
        do {
            print("저장완료")
            try context.save()
//            self.fetchAllergies()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // coredata fetch
    func fetchAllergies() {
        print("알러지 불러오기 코어데이터")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let allergies = try context.fetch(CoreAllergy.fetchRequest()) as! [CoreAllergy]

            var result = [Allergy]()
            for allergy in allergies {
                print(allergy,"zzz")
                result.append(Allergy(allergyName: allergy.allergyName ?? "nothing", myAllergy: allergy.myAllergy))
            }
            
            result.sort { $0.allergyName < $1.allergyName }
            self.testAllergy = result // testAllergy에 불러온값 저장
            
            
            print(result,"불러온값 있음?")
            // result 변수에 [Allergy]가 담겨있습니다.
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    func deleteAlelrgies() {
//        print("알러지 삭제 코어데이터")
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let allergies = context.fetch(CoreAllergy.fetchRequest()) as! [CoreAllergy]
//        for allergy in allergies {
//            context.delete(allergy)
//        }
//    }
//
    
//    func deleteAlelrgies() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        for allergy in testAllergy {
//            if let allergyManagedObject = allergy as? NSManagedObject {
//                context.delete(allergyManagedObject)
//            }
//        }
//    }
    
    func deleteAlelrgies() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreAllergy")

        do {
            let objects = try context.fetch(fetchRequest) as! [CoreAllergy]
            for object in objects {
                context.delete(object)
            }
            try context.save()
        } catch let error as NSError {
            print("Error while deleting all data from Core Data: \(error), \(error.userInfo)")
        }
    }

}


