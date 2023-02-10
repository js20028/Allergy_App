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
    
    
    var testAllergy: [Allergy] = []
            
    // value에는 coredata에서 받아온 값을 넣어줌 (일단은 임시로 testAllergy를 넣음)
    lazy var totalAllergy = PublishRelay<[Allergy]>()
    
    let disposeBag = DisposeBag()
    
    init() {
        // 첨에 allergyModel이 init될때 coredata 불러오기
        fetchAllergies()

        totalAllergy.bind(onNext: { allergies in
            // 여기에 totalAllergy값을 coredata에 저장
            self.testAllergy = allergies
            self.testAllergy.sort { $0.allergyName > $1.allergyName }
            
            self.deleteAlelrgies()
            self.saveAllergies()
            
            
            
            print(self.testAllergy,".  전체 알러지는?")
            
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


