//
//  AllergyResultModel.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/02/09.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class AllergyResultModel {
    
    let disposeBag = DisposeBag()
    
    var allergyResultList: [AllergyResult] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    init() {
        
        allergyResultList = self.getAllergyResultList()
        
    }
    
    func saveAllergyResult(allergyResult: AllergyResult) {

        let entity = NSEntityDescription.entity(forEntityName: "CoreAllergyResult", in: context)

        if let entity = entity {
            let allergyResultEntity = NSManagedObject(entity: entity, insertInto: context)
            allergyResultEntity.setValue(allergyResult.date, forKey: "createDate")
            allergyResultEntity.setValue(allergyResult.productName, forKey: "productName")
            allergyResultEntity.setValue(allergyResult.productIngredient, forKey: "productIngredient")
            allergyResultEntity.setValue(allergyResult.productAllergy, forKey: "productAllergy")
            allergyResultEntity.setValue(allergyResult.compareResult, forKey: "compareResult")

            do {
                try context.save()
                
                print("coredata 저장됨")
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAllergyResult(indexPath: IndexPath) {
        
        guard let fetchResult =  fetchAllergyResult() else { return }
        context.delete(fetchResult[indexPath.row])
        
        do {
            try context.save()
            print("coredata 삭제 후 저장됨")
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAllergyResult() -> [CoreAllergyResult]? {
        
        do {
            let allergyResult = try context.fetch(CoreAllergyResult.fetchRequest()) as! [CoreAllergyResult]
            allergyResult.forEach {
                print($0.createDate!)
                print($0.productName!)
                print($0.productIngredient!)
                print($0.compareResult!)
            }
            return allergyResult
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getAllergyResultList() -> [AllergyResult] {
        var resultList = [AllergyResult]()
        guard let fetchResult =  fetchAllergyResult() else { return [] }
        
        for result in fetchResult {
            let allergyResult = AllergyResult(date: result.createDate ?? Date() , productName: result.productName ?? "", productIngredient: result.productIngredient ?? "", productAllergy: result.productAllergy ?? "", compareResult: result.compareResult ?? "")
            resultList.append(allergyResult)
        }
        
        return resultList
    }
}
