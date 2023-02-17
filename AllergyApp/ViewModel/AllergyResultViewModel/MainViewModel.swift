//
//  MainViewModel.swift
//  AllergyApp
//
//  Created by 곽재선 on 2023/01/25.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    let disposeBag = DisposeBag()
    
    let allergyModel: AllergyModel
    
    let fetchBarcodeInfo: FetchBarcodeInfo
    let fetchProductInfo: FetchProductInfo
    
    let popupTitleText = BehaviorSubject<String>(value: "스캔 성공")
    let popupContentText = BehaviorSubject<String>(value: "결과를 확인하시겠습니까?")
    let popupCheckResultButtonIsHidden = BehaviorSubject(value: false)
    
    let barcodeSubject = PublishSubject<String>()
    let productSubject = PublishSubject<String>()
    
    let resultSubject = PublishSubject<AllergyResult>()
    
//    var testString: String = ""
    var barcode = ""
    
    let checkResultButtonTapped = PublishSubject<Void>()
    let scanButtonTapped = PublishSubject<Void>()
    
    init(allergyModel: AllergyModel, fetchBarcodeInfo: FetchBarcodeInfo, fetchProductInfo: FetchProductInfo) {
        self.allergyModel = allergyModel
        self.fetchBarcodeInfo = fetchBarcodeInfo
        self.fetchProductInfo = fetchProductInfo
        
        
        
        
        
        // 팝업창 확인하기 클릭시 결과 확인
        checkResultButtonTapped.subscribe(onNext: { _ in
            fetchBarcodeInfo.fetchBarcodeRx(barcode: self.barcode)
                .subscribe(onNext: { [weak self] barcode in
                    print(barcode.C005.row[0].PRDLST_REPORT_NO, "바코드 성공")
                    self?.productSubject.onNext(barcode.C005.row[0].PRDLST_REPORT_NO)
                    
                }, onError: { error in
                    
                    print(error, "fetchBarcodeRx 실패")
                    self.popupTitleText.onNext("api 불러오기 실패")
                    self.popupContentText.onNext("fetchBarcodeRx 실패")
                    self.popupCheckResultButtonIsHidden.onNext(true)
                    
                })
                .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        
        
        // 바코드 스캔하기 버튼 클릭시 바코드 인식
        barcodeSubject.bind(onNext: { code in
            self.barcode = code
        }).disposed(by: disposeBag)
        
        
        
        
        productSubject
            .subscribe(onNext: { productNum in
                fetchProductInfo.fetchProductRx(productNum: productNum)
                    .subscribe(onNext: { [weak self] productData in
                        let allergyResult = self?.compareAllergy(response: productData)
                        self?.resultSubject.onNext(allergyResult ?? AllergyResult(date: Date(), productName: "제품명 오류", productIngredient: "제품 성분 오류", productAllergy: "제품 알러지 오류", compareResult: "비교 결과 오류"))
//                        self?.testString = product
//                        print(allergyResult, "완성")
    
                    }, onError: { _ in
                        print("fetchProductRx 실패")
                        self.popupTitleText.onNext("api 불러오기 실패")
                        self.popupContentText.onNext("fetchProductRx 실패")
                        self.popupCheckResultButtonIsHidden.onNext(true)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    func compareAllergy(response: Response) -> AllergyResult {
        
        let item = response.body.items[0].item
        
        let myAllergyList = allergyModel.testAllergy
            .filter { $0.myAllergy == true }
            .map { $0.allergyName }
        print(myAllergyList, "내 알러지 리스트 필터한거")
        
        var resultList: [String] = []
        
        for myAllergy in myAllergyList {
            if item.rawmtrl.contains(myAllergy) || item.allergy.contains(myAllergy) {
                resultList.append(myAllergy)
            }
        }
        
        let compareResultString =
        resultList == [] ? "알러지가 없습니다" : resultList.joined(separator: ", " ) + " 알러지!!!"
        
        let allergyResult = AllergyResult(date: Date(), productName: item.prdlstNm, productIngredient: item.rawmtrl, productAllergy: item.allergy, compareResult: compareResultString)
        
        return allergyResult
    }
}
